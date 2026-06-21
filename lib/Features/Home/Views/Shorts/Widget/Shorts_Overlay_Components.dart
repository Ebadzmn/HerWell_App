import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Controller/Shorts_Video_Controller.dart';

class ShortsOverlayComponents {
  static Widget buildVideoSlider(String videoUrl) {
    if (!Get.isRegistered<ShortsVideoController>(tag: videoUrl)) {
      return const SizedBox.shrink();
    }
    final videoController = Get.find<ShortsVideoController>(tag: videoUrl);

    return Obx(() {
      final pos = videoController.position.value.inMilliseconds.toDouble();
      final dur = videoController.duration.value.inMilliseconds.toDouble();

      return SliderTheme(
        data: SliderTheme.of(Get.context!).copyWith(
          trackHeight: 2.h,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white.withOpacity(0.2),
          thumbColor: Colors.white,
          overlayColor: Colors.white.withOpacity(0.1),
        ),
        child: Slider(
          value: pos.clamp(0.0, dur),
          max: dur > 0 ? dur : 1.0,
          onChanged: (value) {
            videoController.seekTo(Duration(milliseconds: value.toInt()));
          },
        ),
      );
    });
  }

  static Widget buildCentralPlayButton(String videoUrl) {
    if (!Get.isRegistered<ShortsVideoController>(tag: videoUrl)) {
      return const SizedBox.shrink();
    }
    final videoController = Get.find<ShortsVideoController>(tag: videoUrl);

    return Center(
      child: GestureDetector(
        onTap: () => videoController.togglePlayPause(),
        child: Obx(() {
          if (!videoController.showPlayButton.value) {
            return const SizedBox.shrink();
          }
          return Icon(
            videoController.isPlaying.value ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          );
        }),
      ),
    );
  }

  static Widget buildGradient(Alignment begin, Alignment end, double height) {
    return Positioned(
      top: begin == Alignment.topCenter ? 0 : null,
      bottom: begin == Alignment.bottomCenter ? 0 : null,
      left: 0,
      right: 0,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: [Colors.black.withOpacity(0.55), Colors.transparent],
          ),
        ),
      ),
    );
  }
}
