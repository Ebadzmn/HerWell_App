import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Controller/Shorts_Controller.dart';
import '../Model/shorts_model.dart';
import 'Shorts_InfoOverlay.dart';
import 'Shorts_SideButton.dart';
import 'Shorts_Overlay_Components.dart';

class ShortsFullSeriesOverlay extends StatelessWidget {
  final ShortsController controller;
  final ShortsModel shorts;
  final VoidCallback? onBack;

  const ShortsFullSeriesOverlay({
    super.key,
    required this.controller,
    required this.shorts,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Top Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack ?? () => controller.toggleFullSeriesMode(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                CustomText(
                  text: "EP.11 Seaside",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () =>
                      controller.showPlaybackSpeedBottomSheet(shorts.videoUrl),
                  child: Row(
                    children: [
                      Icon(Icons.speed, color: Colors.white, size: 18.sp),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: "Speed",
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: () => controller.toggleMoreMenu(),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Central Play Button
        ShortsOverlayComponents.buildCentralPlayButton(shorts.id),

        // Right Side Buttons
        Positioned(
          right: 16.w,
          bottom: 150.h,
          child: Column(
            children: [
              Obx(() => ShortsSideButton(
                iconPath: AppIcons.save_icon,
                label: controller.savedIds.contains(shorts.id) ? "Saved" : "List",
                color: controller.savedIds.contains(shorts.id) ? null : Colors.white,
                onTap: () => controller.addToCollection(shorts.id),
              )),
              SizedBox(height: 16.h),
              ShortsSideButton(
                iconPath: AppIcons.episode_icon,
                label: "Episodes",
                onTap: () => controller.toggleEpisodePopup(),
              ),
              SizedBox(height: 16.h),
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
              isEpisodeInfo: false,
              isExpanded: controller.isDescriptionExpanded.value,
              onMoreTap: () => controller.toggleDescription(),
            ),
          ),
        ),
        // // More Button
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

        // Progress Bar (Full Series View)
        Positioned(
          bottom: 55.h,
          left: 10.w,
          right: 10.w,
          child: ShortsOverlayComponents.buildVideoSlider(shorts.id),
        ),

        // Reward Icon with Close Button (Top Right)
        Obx(
          () => controller.showRewardIcon.value
              ? Positioned(
                  top: 90.h,
                  right: 12.w,
                  child: SizedBox(
                    width: 60.w, // Large enough to cover coin and close button
                    height: 60.h,
                    child: Stack(
                      children: [
                        // Main Reward Coin
                        Positioned(
                          bottom: 10,
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.rewardsScreen);
                            },
                            child: SvgPicture.asset(
                              AppIcons.short_reword_icon,
                              width: 24.w,
                              height: 24.w,
                            ),
                          ),
                        ),
                        // Close Button (Top Right)
                        Positioned(
                          top: -0,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              controller.showRewardIcon.value = false;
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Color(0xFF292929),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 10.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        // Bottom VIP Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: Colors.black,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0D68A).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFFF0D68A),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.vignette,
                        color: const Color(0xFFF0D68A),
                        size: 16.sp,
                      ),
                      SizedBox(width: 6.w),
                      CustomText(
                        text: "Join membership",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF0D68A),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
