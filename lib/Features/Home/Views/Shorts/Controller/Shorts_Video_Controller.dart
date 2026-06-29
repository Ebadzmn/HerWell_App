import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:uremz100/Data/Repositories/content_details_repository.dart';

class ShortsVideoController extends GetxController with WidgetsBindingObserver {
  final String videoUrl;
  final String? contentId;
  VideoPlayerController? videoPlayerController;

  var isInitialized = false.obs;
  var isPlaying = false.obs;
  var hasStartedPlaying = false.obs;
  var hasError = false.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var playbackSpeed = 1.0.obs;
  var showPlayButton = true.obs;
  var isMuted = true.obs;
  var isLoading = false.obs;

  Timer? _progressTrackingTimer;

  final int startSeconds;

  ShortsVideoController(this.videoUrl, {this.contentId, this.startSeconds = 0});

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initializeAndPlay() async {
    if (videoPlayerController != null) {
      if (!isPlaying.value) playVideo();
      return;
    }

    isLoading.value = true;
    hasStartedPlaying.value = true;
    
    // Trim the video URL to avoid hidden spaces
    final trimmedUrl = videoUrl.trim();
    String finalUrl = trimmedUrl.replaceFirst('http://', 'https://');
    
    debugPrint("Initializing video player for URL: $finalUrl");
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(finalUrl));

    try {
      await videoPlayerController!.initialize();
      if (!isClosed) {
        isInitialized.value = true;
        duration.value = videoPlayerController!.value.duration;

        if (startSeconds > 0) {
          debugPrint("Seeking video to start position: $startSeconds seconds");
          await videoPlayerController!.seekTo(Duration(seconds: startSeconds));
        }

        videoPlayerController!.setLooping(true);
        videoPlayerController!.setVolume(isMuted.value ? 0.0 : 1.0);

        videoPlayerController!.addListener(() {
          if (!isClosed && videoPlayerController!.value.hasError) {
            hasError.value = true;
            debugPrint("Video player reported error: ${videoPlayerController!.value.errorDescription}");
          }
          if (!isClosed && videoPlayerController!.value.isInitialized) {
            position.value = videoPlayerController!.value.position;
          }
        });

        playVideo();

        if (contentId != null && contentId!.isNotEmpty) {
          _fetchWatchProgressAndSeek();
        }
      }
    } catch (e, stack) {
      debugPrint("Error initializing video player for URL $finalUrl: $e\n$stack");
      if (!isClosed) hasError.value = true;
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  Future<void> _fetchWatchProgressAndSeek() async {
    try {
      final repo = Get.find<ContentDetailsRepository>();
      final progressRes = await repo.getWatchProgress(contentId!);
      if (progressRes.isSuccess && progressRes.data != null && !isClosed && videoPlayerController != null) {
        final progressData = progressRes.data!;
        final watched = progressData['watchedSeconds'] is int 
            ? progressData['watchedSeconds'] as int 
            : (int.tryParse(progressData['watchedSeconds']?.toString() ?? '') ?? 0);
        final total = progressData['totalDuration'] is int 
            ? progressData['totalDuration'] as int 
            : (int.tryParse(progressData['totalDuration']?.toString() ?? '') ?? 0);
        if (watched > 0 && (total == 0 || watched < total)) {
          await videoPlayerController!.seekTo(Duration(seconds: watched));
          debugPrint("Dynamically sought video to $watched seconds");
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch initial progress asynchronously: $e");
    }
  }

  void _startPlayButtonTimer() {
    showPlayButton.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!isClosed && isPlaying.value) {
        showPlayButton.value = false;
      }
    });
  }

  void playVideo() {
    if (isClosed || videoPlayerController == null) return;
    if (videoPlayerController!.value.isInitialized &&
        !videoPlayerController!.value.isPlaying) {
      videoPlayerController!.play();
      isPlaying.value = true;
      hasStartedPlaying.value = true;
      _startPlayButtonTimer();
      _startProgressTracking();
    }
  }

  void pauseVideo() {
    if (isClosed || videoPlayerController == null) return;
    if (videoPlayerController!.value.isInitialized &&
        videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      isPlaying.value = false;
      showPlayButton.value = true;
      _stopProgressTracking();
      _sendProgressToBackend();
    }
  }

  void togglePlayPause() {
    if (videoPlayerController == null) {
      initializeAndPlay();
      return;
    }
    if (videoPlayerController!.value.isPlaying) {
      pauseVideo();
    } else {
      playVideo();
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    videoPlayerController?.setVolume(isMuted.value ? 0.0 : 1.0);
  }

  void seekTo(Duration pos) {
    videoPlayerController?.seekTo(pos);
    position.value = pos;
  }

  void seekBy(int seconds) {
    if (videoPlayerController == null) return;
    final newPos = position.value + Duration(seconds: seconds);
    final clampedPos = newPos.inMilliseconds < 0
        ? Duration.zero
        : newPos > duration.value
            ? duration.value
            : newPos;
    seekTo(clampedPos);
  }

  void setPlaybackSpeed(double speed) {
    videoPlayerController?.setPlaybackSpeed(speed);
    playbackSpeed.value = speed;
  }

  void _startProgressTracking() {
    _progressTrackingTimer?.cancel();
    if (contentId == null || contentId!.isEmpty) return;

    _progressTrackingTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _sendProgressToBackend();
    });
  }

  void _stopProgressTracking() {
    _progressTrackingTimer?.cancel();
  }

  Future<void> _sendProgressToBackend() async {
    if (contentId == null || contentId!.isEmpty || videoPlayerController == null) return;
    
    final currentSeconds = videoPlayerController!.value.position.inSeconds;
    if (currentSeconds <= 0) return;

    try {
      final repo = Get.find<ContentDetailsRepository>();
      await repo.trackProgress(contentId!, currentSeconds);
      debugPrint("Tracked progress for $contentId: $currentSeconds seconds");
    } catch (e) {
      debugPrint("Failed to track progress for $contentId: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _sendProgressToBackend();
    }
  }

  void disposeVideo() {
    _stopProgressTracking();
    _sendProgressToBackend();
    videoPlayerController?.pause();
    videoPlayerController?.dispose();
    videoPlayerController = null;
    
    if (!isClosed) {
      isInitialized.value = false;
      isPlaying.value = false;
      hasStartedPlaying.value = false;
      hasError.value = false;
      position.value = Duration.zero;
      duration.value = Duration.zero;
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    disposeVideo();
    super.onClose();
  }
}