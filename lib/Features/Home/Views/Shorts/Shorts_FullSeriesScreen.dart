import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/LoginPopup.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Bottom_NabBar/Controller/Bottom_NabBar_Controller.dart';
import 'Controller/Shorts_Controller.dart';
import 'Widget/Shorts_FullSeriesOverlay.dart';
import 'Widget/Shorts_VideoPlayer.dart';

class ShortsFullSeriesScreen extends StatelessWidget {
  const ShortsFullSeriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShortsController());

    if (Get.arguments != null && Get.arguments is Map && (Get.arguments as Map).containsKey('playbackUrl')) {
      controller.handleArguments(Get.arguments);
    }

    // Force Full Series Mode on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isFullSeriesMode.value = true;
      try {
        final navController = Get.find<NavigationController>();
        navController.toggleBottomNav(false);
      } catch (e) {}
    });

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
        } else {
          // Exit Full Series Mode and Go Back
          controller.exitFullSeries();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Obx(() {
              if (controller.shortsList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF76212),
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
                        key: ValueKey(shorts.id),
                        videoUrl: shorts.videoUrl, 
                        posterUrl: shorts.posterUrl,
                        id: shorts.id,
                        index: index,
                      ),
              
                      // Force Full Series Overlay
                      ShortsFullSeriesOverlay(
                        controller: controller,
                        shorts: shorts,
                        onBack: () => controller.exitFullSeries(),
                      ),
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

  Widget _buildMoreMenu(BuildContext context, ShortsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF292929),
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
                    color: const Color(0xFFE3E3E3),
                  ),
                  GestureDetector(
                    onTap: () => controller.toggleMoreMenu(),
                    child: Icon(
                      Icons.close,
                      color: const Color(0xFFE3E3E3),
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
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 406.h,
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
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
                    CustomText(
                      text: "Episodes",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    SizedBox(height: 30.h),
                    _buildRangeSection(controller),
                    SizedBox(height: 24.h),
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

  Widget _buildRangeSection(ShortsController controller) {
    return Obx(() {
      final details = controller.currentContentDetails.value;
      if (details == null || details.seasons.isEmpty) return const SizedBox.shrink();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: details.seasons.map((season) {
            return Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: _buildEpisodeRangeTab(controller, season.title, season.id),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildEpisodeGrid(ShortsController controller) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoadingDetails.value) {
           return const Center(child: CircularProgressIndicator(color: Color(0xFFF76212)));
        }
        final episodesList = controller.episodes;
        if (episodesList.isEmpty) {
           return const Center(child: Text("No episodes available.", style: TextStyle(color: Colors.white)));
        }
        return GridView.builder(
          padding: EdgeInsets.only(bottom: 20.h),
          shrinkWrap: false,
          physics: const BouncingScrollPhysics(),
          itemCount: episodesList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final episode = episodesList[index];
            bool isLocked = episode.requiredCoin > 0;
            return _buildEpisodeItem(controller, episode.episodeNumber, isLocked, episode);
          },
        );
      }),
    );
  }

  Widget _buildEpisodeItem(
    ShortsController controller,
    int episodeNum,
    bool isLocked,
    dynamic episodeModel,
  ) {
    return GestureDetector(
      onTap: () {
        controller.selectEpisode(episodeModel);
      },
      child: Stack(
        children: [
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

  Widget _buildEpisodeRangeTab(ShortsController controller, String title, String seasonId) {
    return Obx(() {
      bool isSelected = controller.selectedSeasonId.value == seasonId;
      return GestureDetector(
        onTap: () => controller.selectSeason(seasonId),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: title,
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
