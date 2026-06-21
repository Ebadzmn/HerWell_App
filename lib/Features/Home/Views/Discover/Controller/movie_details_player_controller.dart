import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:uremz100/core/network/network_caller.dart';
import 'package:uremz100/Features/Home/Views/Shorts/More/Modet/more_model.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:uremz100/Features/Home/Controllers/pip_controller.dart';
import 'package:uremz100/Features/Home/Views/Shorts/Model/shorts_model.dart';
import 'package:uremz100/Data/Repositories/content_details_repository.dart';
import 'package:uremz100/Data/Models/content_details_model.dart';
import 'package:uremz100/Config/routes.dart';

class MovieDetailsPlayerController extends GetxController {
  final String movieId;
  final int startSeconds;
  MovieDetailsPlayerController({required this.movieId, this.startSeconds = 0});

  final NetworkCaller _networkCaller = NetworkCaller();
  late final ContentDetailsRepository _contentDetailsRepository;

  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  ContentDetailsModel? movieDetails;

  var selectedSeasonId = ''.obs;
  var isLoadingEpisodes = false.obs;
  var episodes = <EpisodeModel>[].obs;

  VideoPlayerController? videoPlayerController;
  var isVideoInitialized = false.obs;
  var isPlaying = false.obs;
  var isBuffering = false.obs;
  var videoPosition = Duration.zero.obs;
  var videoDuration = Duration.zero.obs;
  var isFullscreen = false.obs;
  var showControls = true.obs;

  Timer? _progressTimer;
  int _lastTrackedSeconds = 0;

  @override
  void onInit() {
    super.onInit();
    _contentDetailsRepository = Get.find<ContentDetailsRepository>();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _contentDetailsRepository.getContentDetails(movieId);

      if (response.isSuccess && response.data != null) {
        movieDetails = response.data;
        
        int initialSeconds = startSeconds;
        
        if (initialSeconds == 0) {
          final progressResponse = await _contentDetailsRepository.getWatchProgress(movieId);
          if (progressResponse.isSuccess && progressResponse.data != null) {
             final data = progressResponse.data!;
             if (data.containsKey('watchedSeconds')) {
                 final watchedSecondsObj = data['watchedSeconds'];
                 if (watchedSecondsObj is num) {
                     initialSeconds = watchedSecondsObj.toInt();
                 }
             }
          }
        }
        
        if (movieDetails!.type == 'SERIES' && movieDetails!.seasons.isNotEmpty) {
          selectSeason(movieDetails!.seasons.first.id, autoPlayFirstEpisode: true);
        } else if (movieDetails!.videoUrl.isNotEmpty) {
          _initializeVideoPlayer(movieDetails!.videoUrl, initialSeconds);
        }
      } else {
        hasError.value = true;
        errorMessage.value = response.message ?? 'Failed to load content details';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeVideoPlayer(String url, int initialSeconds) {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        isVideoInitialized.value = true;
        videoDuration.value = videoPlayerController!.value.duration;
        if (initialSeconds > 0) {
          videoPlayerController!.seekTo(Duration(seconds: initialSeconds));
        }
        videoPlayerController!.play();
        isPlaying.value = true;
        _hideControlsTimer();
        _startProgressTracking();
        update();
      }).catchError((e) {
        print("Video init error: $e");
      });

    videoPlayerController!.addListener(() {
      isPlaying.value = videoPlayerController!.value.isPlaying;
      isBuffering.value = videoPlayerController!.value.isBuffering;
      videoPosition.value = videoPlayerController!.value.position;
    });
  }

  void togglePlayPause() {
    if (videoPlayerController == null || !isVideoInitialized.value) return;
    if (isPlaying.value) {
      videoPlayerController!.pause();
      _stopProgressTracking();
    } else {
      videoPlayerController!.play();
      _startProgressTracking();
    }
    showControls.value = true;
    _hideControlsTimer();
  }

  void seekTo(Duration position) {
    videoPlayerController?.seekTo(position);
  }

  void _hideControlsTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (isPlaying.value && showControls.value) {
        showControls.value = false;
      }
    });
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    if (showControls.value) {
      _hideControlsTimer();
    }
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    if (isFullscreen.value) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    }
    return '$views views';
  }

  void _startProgressTracking() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (videoPlayerController != null && isPlaying.value) {
        final currentSeconds = videoPlayerController!.value.position.inSeconds;
        if (currentSeconds > _lastTrackedSeconds) {
          _lastTrackedSeconds = currentSeconds;
          _contentDetailsRepository.trackProgress(movieId, currentSeconds);
        }
      }
    });
  }

  void _stopProgressTracking() {
    _progressTimer?.cancel();
    if (videoPlayerController != null) {
      final currentSeconds = videoPlayerController!.value.position.inSeconds;
      if (currentSeconds > _lastTrackedSeconds) {
        _lastTrackedSeconds = currentSeconds;
        _contentDetailsRepository.trackProgress(movieId, currentSeconds);
      }
    }
  }

  Future<void> addToMyList() async {
    try {
      final response = await _contentDetailsRepository.addToCollection(movieId);
      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Added to My List',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to add to My List',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void triggerPipAndClose() {
    if (movieDetails == null) {
      Get.back();
      return;
    }
    
    _stopProgressTracking();

    if (!isPlaying.value) {
      Get.back();
      return;
    }

    final shortModel = ShortsModel(
      id: movieId,
      videoUrl: movieDetails!.videoUrl,
      posterUrl: movieDetails!.posterUrl,
      title: movieDetails!.title,
      description: movieDetails!.description,
      episode: '1',
      season: '1',
    );

    Duration? currentPos;
    if (videoPlayerController != null) {
      currentPos = videoPlayerController!.value.position;
      videoPlayerController!.pause();
    }

    PipController.to.showPip(shortModel, startPosition: currentPos, route: Routes.movieDetailScreen);
    
    Get.back();
  }

  void playTrailerAsShort() {
    if (movieDetails == null || movieDetails!.trailerUrl.isEmpty) return;
    
    videoPlayerController?.pause();

    Get.toNamed(Routes.shortsScreen, arguments: {
      'playbackUrl': movieDetails!.trailerUrl,
      'title': '${movieDetails!.title} - Trailer',
      'description': movieDetails!.description,
      'posterUrl': movieDetails!.posterUrl,
      'contentId': movieId,
    });
  }

  void selectSeason(String seasonId, {bool autoPlayFirstEpisode = false}) {
    if (selectedSeasonId.value == seasonId) return;
    selectedSeasonId.value = seasonId;
    fetchEpisodes(seasonId, autoPlayFirstEpisode: autoPlayFirstEpisode);
  }

  Future<void> fetchEpisodes(String seasonId, {bool autoPlayFirstEpisode = false}) async {
    isLoadingEpisodes.value = true;
    final response = await _contentDetailsRepository.getSeasonEpisodes(seasonId);
    if (response.isSuccess && response.data != null) {
      episodes.assignAll(response.data!);
      if (autoPlayFirstEpisode && episodes.isNotEmpty) {
        playEpisode(episodes.first);
      }
    } else {
      episodes.clear();
      Get.snackbar(
        'Error',
        response.message ?? 'Failed to load episodes',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
    isLoadingEpisodes.value = false;
  }

  void playEpisode(EpisodeModel episode) {
    if (episode.videoUrl.isNotEmpty) {
      videoPlayerController?.pause();
      _stopProgressTracking();
      _initializeVideoPlayer(episode.videoUrl, 0); 
    } else {
      Get.snackbar(
        'Error',
        'No video available for this episode',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    _stopProgressTracking();
    videoPlayerController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onClose();
  }
}
