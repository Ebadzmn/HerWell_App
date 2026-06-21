import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/LoginPopup.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'Controller/Shorts_Controller.dart';
import 'Widget/Shorts_VideoPlayer.dart';
import 'Widget/Shorts_DefaultOverlay.dart';
import 'Widget/Shorts_FullSeriesOverlay.dart';
import '../Bottom_NabBar/Controller/Bottom_NabBar_Controller.dart';

class ShortsScreen extends StatelessWidget {
  const ShortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShortsController());
    if (Get.arguments != null && Get.arguments is Map && (Get.arguments as Map).containsKey('playbackUrl')) {
      controller.handleArguments(Get.arguments);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (controller.showMoreMenu.value) {
          controller.toggleMoreMenu();
        } else if (controller.showEpisodePopup.value) {
          controller.toggleEpisodePopup();
        } else if (controller.showLoginPopup.value) {
          controller.toggleLoginPopup();
        } else if (controller.isFullSeriesMode.value) {
          controller.toggleFullSeriesMode();
        } else {
          // If in Shorts mode and no popups, go back to Discover tab (index 0)
          controller.pauseCurrentVideo(); // Pause video before switching
          controller.triggerPip();

          try {
            final navController = Get.find<NavigationController>();
            if (navController.currentIndex.value != 0) {
              navController.changeIndex(0);
            } else {
              // If already in Discover, handle accordingly
            }
          } catch (e) {
            // navigation logic fallback
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Obx(() {
              if (controller.isInitialLoading.value && controller.shortsList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.shortsList.isEmpty) {
                return const Center(
                  child: CustomText(
                    text: "No Shorts Available",
                    color: Colors.white,
                    fontSize: 16,
                  ),
                );
              }
              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.shortsList.length,
                onPageChanged: (index) => controller.currentIndex.value = index,
                itemBuilder: (context, index) {
                  final shorts = controller.shortsList[index];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Video
                      ShortsVideoPlayer(
                        videoUrl: shorts.videoUrl, 
                        posterUrl: shorts.posterUrl,
                        id: shorts.id,
                        index: index,
                      ),

                      // Overlay Content (Conditional based on Mode)
                      Obx(() {
                        final isFullMode = controller.isFullSeriesMode.value;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            if (!isFullMode)
                              ShortsDefaultOverlay(
                                shorts: shorts,
                                controller: controller,
                              )
                            else
                              ShortsFullSeriesOverlay(
                                controller: controller,
                                shorts: shorts,
                              ),
                          ],
                        );
                      }),
                    ],
                  );
                },
              );
            }),

            // Episode Selection Popup
            Obx(
              () => controller.showEpisodePopup.value
                  ? _buildEpisodePopup(context, controller)
                  : const SizedBox.shrink(),
            ),

            // More Menu Overlay
            Obx(
              () => controller.showMoreMenu.value
                  ? GestureDetector(
                      onTap: () => controller.toggleMoreMenu(),
                      child: Container(
                        color: Colors.black45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [_buildMoreMenu(context, controller)],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Login Popup
            Obx(
              () => controller.showLoginPopup.value
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: LoginPopup(
                        onSignIn: () {
                          controller.toggleLoginPopup();
                          Get.toNamed(Routes.signinScreen);
                        },
                        onClose: () => controller.toggleLoginPopup(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  ///  More Menu ==========================================================================

  Widget _buildMoreMenu(BuildContext context, ShortsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Color(0xFF292929),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "More",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE3E3E3),
                  ),
                  GestureDetector(
                    onTap: () => controller.toggleMoreMenu(),
                    child: Icon(
                      Icons.close,
                      color: Color(0xFFE3E3E3),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _buildDivider(),

            // Menu Items
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              child: _buildMoreMenuItem(
                iconPath: AppIcons.speed_icon,
                title: "Playback Speed",
                value: controller.playbackSpeed.value,
                showArrow: true,
                onTap: () => _showSpeedSelection(context, controller),
              ),
            ),
            _buildDivider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              child: _buildMoreMenuItem(
                iconPath: AppIcons.quality_icon,
                title: "Quality",
                value: controller.videoQuality.value,
                showArrow: true,
                onTap: () => _showQualitySelection(context, controller),
              ),
            ),
            _buildDivider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
              child: _buildMoreMenuItem(
                iconPath: AppIcons.picture_icon,
                title: "Picture in Picture",
                trailing: Obx(
                  () => SizedBox(
                    height: 26.h,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                        value: controller.isPipEnabled.value,
                        onChanged: (v) => controller.togglePip(),
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFFE8124C),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
                showArrow: false,
                onTap: () {},
              ),
            ),
            _buildDivider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              child: _buildMoreMenuItem(
                iconPath: AppIcons.share_icon,
                title: "Share",
                showArrow: true,
                onTap: () {},
              ),
            ),
            _buildDivider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              child: _buildMoreMenuItem(
                iconPath: AppIcons.report_icon,
                title: "Report",
                showArrow: true,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodePopup(BuildContext context, ShortsController controller) {
    return GestureDetector(
      onTap: () => controller.toggleEpisodePopup(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent, // Shadow/Dim background removed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {}, // Prevent closing when clicking inside
              child: Container(
                // Respect the bottom margin
                width: double.infinity,
                height: 406.h,
                padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    CustomText(
                      text: "Episodes",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    SizedBox(height: 30.h),

                    // 1. Episode Range Section (Custom Widget)
                    _buildRangeSection(controller),

                    SizedBox(height: 24.h),

                    // 2. Episodes Grid Section (Custom Widget)
                    _buildEpisodeGrid(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. Episode Range Section ---
  Widget _buildRangeSection(ShortsController controller) {
    return Row(
      children: [
        _buildEpisodeRangeTab(controller, "1-25"),
        SizedBox(width: 40.w),
        _buildEpisodeRangeTab(controller, "26-43"),
        SizedBox(width: 40.w),
        _buildEpisodeRangeTab(controller, "44-93"),
      ],
    );
  }

  // --- 2. Episodes Grid Section ---
  Widget _buildEpisodeGrid(ShortsController controller) {
    return Expanded(
      child: Obx(() {
        final episodes = controller.episodesForSelectedRange;
        return GridView.builder(
          padding: EdgeInsets.only(bottom: 20.h),
          shrinkWrap: false,
          physics: const BouncingScrollPhysics(),
          itemCount: episodes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            int episodeNum = episodes[index];
            bool isLocked = episodeNum > 10;
            return _buildEpisodeItem(controller, episodeNum, isLocked);
          },
        );
      }),
    );
  }

  // --- Episode Item Custom Widget ---
  Widget _buildEpisodeItem(
    ShortsController controller,
    int episodeNum,
    bool isLocked,
  ) {
    return GestureDetector(
      onTap: () => controller.selectEpisode(episodeNum),
      child: Stack(
        children: [
          // Background Tile
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D),
              borderRadius: BorderRadius.circular(6.r),
            ),
            alignment: Alignment.center,
            child: CustomText(
              text: "$episodeNum",
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          // Locked Badge (Top Right)
          if (isLocked)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF76212),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6.r),
                    bottomLeft: Radius.circular(6.r),
                  ),
                ),
                child: Icon(Icons.lock, size: 8.sp, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEpisodeRangeTab(ShortsController controller, String range) {
    return Obx(() {
      bool isSelected = controller.selectedEpisodeRange.value == range;
      return GestureDetector(
        onTap: () => controller.changeEpisodeRange(range),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: range,
              fontSize: 18.sp,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFFF76212)
                  : const Color(0xFF8E8E8E),
            ),
            SizedBox(height: 8.h),
            Container(
              height: 2.h,
              width: 50.w,
              color: isSelected ? const Color(0xFFF76212) : Colors.transparent,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.08),
      height: 1,
      thickness: 1,
    );
  }

  Widget _buildMoreMenuItem({
    required String iconPath,
    required String title,
    String? value,
    Widget? trailing,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              color: Colors.white,
              width: 24.sp,
              height: 24.sp,
            ),
            SizedBox(width: 12.w),
            CustomText(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            const Spacer(),
            if (trailing != null)
              trailing
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value != null)
                    CustomText(
                      text: value,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  if (showArrow) ...[
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showSpeedSelection(BuildContext context, ShortsController controller) {
    final speeds = [
      "0.25x",
      "0.5x",
      "0.75x",
      "Normal",
      "1.25x",
      "1.5x",
      "2.0x",
    ];
    Get.bottomSheet(
      Obx(
        () => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: "Playback Speed",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                SizedBox(height: 20.h),
                ...speeds.asMap().entries.map((entry) {
                  final index = entry.key;
                  final speed = entry.value;
                  final isSelected =
                      controller.playbackSpeed.value ==
                      (speed == "Normal" ? "1.0x" : speed);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: CustomText(
                          text: speed,
                          fontSize: 14.sp,
                          color: isSelected
                              ? AppColors.orange100
                              : Colors.white,
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: AppColors.orange100,
                                size: 20.sp,
                              )
                            : null,
                        onTap: () {
                          controller.updatePlaybackSpeed(
                            speed == "Normal" ? "1.0x" : speed,
                          );
                          Get.back();
                        },
                      ),
                      if (index < speeds.length - 1) _buildDivider(),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQualitySelection(
    BuildContext context,
    ShortsController controller,
  ) {
    final qualities = ["144p", "240p", "360p", "480p", "720p", "1080p", "Auto"];
    Get.bottomSheet(
      Obx(
        () => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: "Video Quality",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                SizedBox(height: 20.h),
                ...qualities.asMap().entries.map((entry) {
                  final index = entry.key;
                  final quality = entry.value;
                  final isSelected = controller.videoQuality.value == quality;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: CustomText(
                          text: quality,
                          fontSize: 14.sp,
                          color: isSelected
                              ? AppColors.orange100
                              : Colors.white,
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: AppColors.orange100,
                                size: 20.sp,
                              )
                            : null,
                        onTap: () {
                          controller.updateVideoQuality(quality);
                          Get.back();
                        },
                      ),
                      if (index < qualities.length - 1) _buildDivider(),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
