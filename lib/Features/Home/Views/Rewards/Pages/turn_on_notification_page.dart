import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uremz100/Features/Home/Views/Rewards/Controller/rewards_controller.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';

class TurnOnNotificationPage extends StatelessWidget {
  const TurnOnNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131416),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Notifications",
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.orange100.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                size: 80.w,
                color: AppColors.orange100,
              ),
            ),
            SizedBox(height: 32.h),
            CustomText(
              text: "Enable Push Notifications",
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: "Stay updated on the latest drama series, special offers, and earn 60 Coins instantly!",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Permission.notification.request();
                  if (result.isGranted) {
                    final RewardsController controller = Get.find<RewardsController>();
                    controller.hasNotificationPermission.value = true;
                    // Directly claim the task from the controller to provide immediate feedback
                    await controller.handleTaskAction("Turn On Notifications");
                    Get.back();
                  } else {
                    Get.snackbar(
                      "Permission Denied",
                      "Notification permission is required to earn this reward.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF1A1B20),
                      colorText: const Color(0xFFEDADA1),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: CustomText(
                  text: "Turn On Notifications",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.back(),
              child: CustomText(
                text: "Maybe Later",
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),
            SizedBox(height: 64.h), // Push content slightly up
          ],
        ),
      ),
    );
  }
}
