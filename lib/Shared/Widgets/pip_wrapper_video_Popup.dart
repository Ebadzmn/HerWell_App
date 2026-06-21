import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Features/Home/Controllers/pip_controller.dart';
import 'package:video_player/video_player.dart';

class PipWrapper extends StatelessWidget {
  final Widget child;
  const PipWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Keep PipController alive globally
    Get.put(PipController());

    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        child,
        Obx(() {
          if (PipController.to.isPipVisible.value) {
            return _DraggablePipOverlay();
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}

class _DraggablePipOverlay extends StatefulWidget {
  @override
  State<_DraggablePipOverlay> createState() => _DraggablePipOverlayState();
}

class _DraggablePipOverlayState extends State<_DraggablePipOverlay> {
  // Initial position of the PiP (bottom left area)
  Offset _pipPosition = Offset(20.w, 550.h);
  final controller = PipController.to;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _pipPosition.dx,
      top: _pipPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _pipPosition += details.delta;
          });
        },
        onTap: () {
          final activeShort = controller.currentShort.value;
          final targetRoute = controller.returnRoute.value;
          if (activeShort != null) {
            int startSeconds = 0;
            if (controller.videoController != null) {
              startSeconds = controller.videoController!.value.position.inSeconds;
            }
            
            controller.closePip();
            
            if (targetRoute == Routes.movieDetailScreen) {
              Get.toNamed(
                Routes.movieDetailScreen,
                arguments: {'movieId': activeShort.id, 'startSeconds': startSeconds},
              );
            } else {
              Get.toNamed(
                Routes.shortsFullSeriesOverlay,
                arguments: {
                  'contentId': activeShort.id,
                  'playbackUrl': activeShort.videoUrl,
                  'title': activeShort.title,
                  'description': activeShort.description,
                  'posterUrl': activeShort.posterUrl,
                  'startSeconds': startSeconds,
                },
              );
            }
          } else {
            controller.closePip();
            if (targetRoute.isNotEmpty) {
              Get.toNamed(targetRoute);
            } else {
              Get.toNamed(Routes.shortsFullSeriesOverlay);
            }
          }
        },
        child: Container(
          width: 120.w,
          height: 150.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            // Outer glowing border representing the active selection or image accent
            border: Border.all(color: Colors.transparent),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Actual Video — reactive: rebuilds when initialized
                Obx(() {
                  if (controller.isVideoInitialized.value &&
                      controller.videoController != null) {
                    return FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.videoController!.value.size.width,
                        height: controller.videoController!.value.size.height,
                        child: VideoPlayer(controller.videoController!),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white54,
                      strokeWidth: 2,
                    ),
                  );
                }),

                // Dark overlay to make icons visible
                Container(color: Colors.black.withOpacity(0.2)),

                // Center Play/Pause button
                Center(
                  child: GestureDetector(
                    onTap: () => controller.togglePlay(),
                    child: Obx(
                      () => Icon(
                        controller.isPlaying.value
                            ? Icons.pause_circle_filled
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),

                // Top Right Close button
                Positioned(
                  top: 7.h,
                  right: 5.w,
                  child: GestureDetector(
                    onPanDown: (_) {}, // absorb taps so drag doesn't trigger
                    onTap: () => controller.closePip(),
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),

                // Bottom Progress Bar (red line like in Netflix/your design)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 50.w, // Simulated progress
                  child: Container(height: 4.h, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
