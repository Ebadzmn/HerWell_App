import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Shared/Widgets/Custom_AppBar.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Field.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'Controller/change_email_controller.dart';

class ChangeEmailScreen extends StatelessWidget {
  ChangeEmailScreen({super.key});

  final controller = Get.put(ChangeEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black100,
      appBar: const CustomAppBar(
        title: "Change Email",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),

            // New Email Field
            CustomText(text: "New Email", fontSize: 14.sp, fontWeight: FontWeight.w400),
            SizedBox(height: 8.h),
            Customtextfield(
              controller: controller.emailController,
              hintText: "Enter your new email",
              obscureText: false,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.h),

            // Password Field
            CustomText(text: "Current Password", fontSize: 14.sp, fontWeight: FontWeight.w400),
            SizedBox(height: 8.h),
            Obx(
              () => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  hintText: "Enter your current password",
                  hintStyle: const TextStyle(color: Color(0xFFCDCDCD)),
                  filled: true,
                  fillColor: AppColors.black100,
                  suffixIcon: GestureDetector(
                    onTap: controller.togglePasswordVisibility,
                    child: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFFCDCDCD),
                      size: 20.sp,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),

            SizedBox(height: 84.h),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!controller.isLoading.value) {
                    controller.requestEmailChange();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                child: Obx(
                  () => controller.isLoading.value
                      ? SizedBox(
                          height: 20.sp,
                          width: 20.sp,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : CustomText(
                          text: "Request Change",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                  backgroundColor: AppColors.gray100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                child: CustomText(
                  text: "Cancel",
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
