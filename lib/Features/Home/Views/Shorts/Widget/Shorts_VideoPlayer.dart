import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'package:video_player/video_player.dart';
import '../Controller/Shorts_Controller.dart';
import '../Controller/Shorts_Video_Controller.dart';

class ShortsVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String posterUrl;
  final String id;
  final int index;

  const ShortsVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.posterUrl,
    required this.id,
    required this.index,
  });

  @override
  State<ShortsVideoPlayer> createState() => _ShortsVideoPlayerState();
}

class _ShortsVideoPlayerState extends State<ShortsVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  late ShortsVideoController controller;
  Worker? _pageWorker;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    int startSeconds = 0;
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['contentId'] == widget.id) {
        startSeconds = args['startSeconds'] as int? ?? 0;
      }
    }

    // Get or create the video controller for this URL
    controller = Get.put(
      ShortsVideoController(widget.videoUrl, contentId: widget.id, startSeconds: startSeconds),
      tag: widget.id,
    );

    // Listen to page swipes: auto-play active video, dispose inactive
    try {
      final shortsController = Get.find<ShortsController>();
      if (shortsController.currentIndex.value == widget.index) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!controller.isClosed) {
            controller.initializeAndPlay();
          }
        });
      }
      _pageWorker = ever(shortsController.currentIndex, (idx) {
        if (controller.isClosed) return;
        if (idx == widget.index) {
          controller.initializeAndPlay();
        } else {
          // Dispose controller when item leaves viewport
          controller.disposeVideo();
        }
      });
    } catch (_) {
      // ShortsController not found
    }
  }

  @override
  void dispose() {
    _pageWorker?.dispose();
    Get.delete<ShortsVideoController>(tag: widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Obx(() {
      if (controller.hasError.value) {
        return const Center(
          child: Icon(Icons.error, color: Colors.white, size: 40),
        );
      }

      return GestureDetector(
        onTap: () => controller.togglePlayPause(),
        onDoubleTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            controller.seekBy(-10); // Seek backward 10s
          } else {
            controller.seekBy(10); // Seek forward 10s
          }
        },
        onLongPressStart: (_) => controller.setPlaybackSpeed(2.0),
        onLongPressEnd: (_) => controller.setPlaybackSpeed(1.0),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            // Video Player or Poster
            Positioned.fill(
              child: controller.isInitialized.value && controller.videoPlayerController != null
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.videoPlayerController!.value.size.width,
                        height: controller.videoPlayerController!.value.size.height,
                        child: VideoPlayer(controller.videoPlayerController!),
                      ),
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        if (widget.posterUrl.isNotEmpty)
                          Image.network(
                            widget.posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                          )
                        else
                          Container(color: Colors.black),
                        // Dark Gradient Overlay for text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            // Loading Indicator
            if (controller.isLoading.value)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // Play Button
            if (!controller.isPlaying.value && !controller.isLoading.value)
              Center(
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppIcons.play_icon,
                    width: 18.w,
                    height: 18.w,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
