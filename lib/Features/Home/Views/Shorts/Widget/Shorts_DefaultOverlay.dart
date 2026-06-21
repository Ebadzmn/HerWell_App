import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Controller/Shorts_Controller.dart';
import '../Model/shorts_model.dart';
import 'Shorts_InfoOverlay.dart';
import 'Shorts_SideButton.dart';
import 'Shorts_Overlay_Components.dart';

class ShortsDefaultOverlay extends StatelessWidget {
  final ShortsController controller;
  final ShortsModel shorts;

  const ShortsDefaultOverlay({
    super.key,
    required this.controller,
    required this.shorts,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Top Gradient
        ShortsOverlayComponents.buildGradient(
          Alignment.topCenter,
          Alignment.bottomCenter,
          150.h,
        ),

        // Central Play Button
        ShortsOverlayComponents.buildCentralPlayButton(shorts.id),

        // Right Side Buttons
        Positioned(
          right: 16.w,
          bottom: 120.h,
          child: Column(
            children: [
              Obx(() => ShortsSideButton(
                iconPath: AppIcons.save_icon,
                label: controller.savedIds.contains(shorts.id) ? "Saved" : "List",
                color: controller.savedIds.contains(shorts.id) ? null : Colors.white,
                onTap: () => controller.addToCollection(shorts.id),
              )),
              SizedBox(height: 20.h),
              ShortsSideButton(
                iconPath: AppIcons.share_icon,
                label: "Share",
                onTap: () {},
              ),
            ],
          ),
        ),

        // Bottom Info
        Positioned(
          left: 16.w,
          bottom: 110.h,
          child: Obx(
            () => ShortsInfoOverlay(
              onTitleTap: () => controller.showMoreDetailsBottomSheet(),
              title: shorts.title,
              description: shorts.description,
              tags: shorts.tags,
              isEpisodeInfo: true,
              isExpanded: controller.isDescriptionExpanded.value,
              onMoreTap: () => controller.toggleDescription(),
            ),
          ),
        ),
        // More Button
        // Positioned(
        //   left: 16.w,
        //   bottom: 85.h,
        //   child: GestureDetector(
        //     onTap: () async {
        //       controller.pauseCurrentVideo();
        //       await Get.toNamed(Routes.moreScreen);
        //       controller.playCurrentVideo();
        //     },
        //     child: CustomText(
        //       text: "More",
        //       fontSize: 12.sp,
        //       fontWeight: FontWeight.w600,
        //       color: const Color(0xFFE6B323),
        //     ),
        //   ),
        // ),

        // Watch Full Series Button
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 30.h,
          child: GestureDetector(
            onTap: () => controller.toggleFullSeriesMode(),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.30),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: CustomText(
                text: "Watch Full Series",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Progress Bar (Shorts View)
        Positioned(
          bottom: 4.h,
          left: 10.w,
          right: 10.w,
          child: ShortsOverlayComponents.buildVideoSlider(shorts.id),
        ),
      ],
    );
  }
}
