import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'package:uremz100/Utils/app_images.dart';
import 'package:uremz100/core/services/storage_service.dart';
import 'Controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            // Profile Header
            Obx(() => Row(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundImage: AssetImage(AppImages.profile_image),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: controller.isLoggedIn.value ? controller.userName.value : "Guest User",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      text: controller.isLoggedIn.value ? "UID: ${controller.uid.value}" : "ID: ${controller.guestId.value}",
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFD4D4D4),
                    ),
                  ],
                ),
              ],
            )),
            SizedBox(height: 34.h),

            // VIP Benefits Card
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFFFFFFFF).withAlpha(13),
                ), // 0.05 * 255 ≈ 13
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6C4E32).withAlpha(128), // 0.5 * 255 ≈ 128
                    const Color(0xFF131416),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.0, 1.0],
                ),
              ),
              child: Column(
                children: [
                  CustomText(
                    text: "Become a VIP- Enjoy All Benefits",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildVipBenefitItem(
                        AppIcons.drama_icon,
                        "Short Drama\nViewing",
                      ),
                      _buildVipBenefitItem(
                        AppIcons.rewards_icon,
                        "Daily VIP\nReward",
                      ),
                      _buildVipBenefitItem(
                        AppIcons.full_hd_icon,
                        "1080p\nFull HD",
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.orange100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "GO",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // My Wallet Section
            Row(
              children: [
                CustomText(
                  text: "My Wallet",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                Spacer(),
                GestureDetector(
                  // onTap: () => Get.toNamed(Routes.settingsScreen),
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(0xFFB7B3B3),
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(color: Color(0xFF424141), height: 1.h),
            SizedBox(height: 25.h),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Coins",
                      fontSize: 16.sp,
                      color: Color(0xFFC9C5C5),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.rewards__rank_icon,
                          height: 24.w,
                          width: 24.w,
                        ),
                        SizedBox(width: 5.w),
                        CustomText(
                          text: "30",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.yellow200,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF76212),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: CustomText(
                    text: "Refill",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Menu List
            _buildMenuItem(
              AppIcons.rewards_icon,
              "Earn Rewards",
              onTap: () => Get.toNamed(Routes.rewardsScreen),
            ),
            _buildMenuItem(
              AppIcons.my_list_icon,
              "My List",
              onTap: () => Get.toNamed(Routes.myListScreen),
            ),

            _buildMenuItem(
              AppIcons.faqs_icon,
              "FAQs",
              //onTap: () => Get.toNamed(Routes.faqsScreen()),
            ),

            _buildMenuItem(
              AppIcons.setting_icon,
              "Settings",
              onTap: () => Get.toNamed(Routes.settingsScreen),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildVipBenefitItem(String iconPath, String label) {
    return Column(
      children: [
        SvgPicture.asset(iconPath, height: 24.w, width: 24.w),
        SizedBox(height: 8.h),
        CustomText(
          text: label,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
          color: AppColors.white100,
        ),
      ],
    );
  }

  Widget _buildMenuItem(dynamic icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Row(
          children: [
            _buildIcon(icon),
            SizedBox(width: 16.w),
            CustomText(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Color(0xFFB7B3B3), size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(dynamic icon) {
    if (icon is String) {
      return SvgPicture.asset(
        icon,
        width: 24.w,
        height: 24.w,
        colorFilter: const ColorFilter.mode(Color(0xFFDBBA8F), BlendMode.srcIn),
      );
    }
    return const SizedBox.shrink();
  }
}
