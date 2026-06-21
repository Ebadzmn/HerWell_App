import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Button.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_images.dart';

class SigninAndSignupScreen extends StatelessWidget {
  const SigninAndSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppImages.signin_singnup_image,
              fit: BoxFit.cover,
            ),
          ),
          // Dark Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 350.h),
                // Logo
                Image.asset(AppImages.app_logo, height: 120.w, width: 120.w),
                SizedBox(height: 18.h),
                // Text
                Text(
                  "LET’S GET STARTED",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white100,
                    letterSpacing: 1.24,
                  ),
                ),
                const Spacer(),
                // Buttons
                CustomButton(
                  text: "Sign in",
                  onPressed: () {
                    Get.toNamed(Routes.signinScreen);
                  },
                ),
                SizedBox(height: 14.h),
                CustomButton(
                  text: "Sign up",
                  backgroundColor: AppColors.white100,
                  textColor: AppColors.red100,
                  onPressed: () {
                    Get.toNamed(Routes.signupScreen);
                  },
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
