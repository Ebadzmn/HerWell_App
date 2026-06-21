import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Shared/Widgets/Custom_AppBar.dart';
import 'package:uremz100/Shared/Widgets/Custom_Button.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Field.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Gray.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_consts.dart';
import 'package:uremz100/Utils/app_images.dart';
import '../../Controllers/auth_controller.dart';

class SetPassScreen extends StatelessWidget {
  SetPassScreen({super.key});

  final TextEditingController NewPasswordController = TextEditingController();
  final TextEditingController ConfromPasswordController =
      TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Reactive variable to control password visibility
  final isConformPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Image.asset(
                    AppImages.sent_otp_image,
                    height: 250.w,
                    width: 250.w,
                  ),
                ),
                SizedBox(height: 24.h),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: "Set Your New Password",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white100,
                  ),
                ),
                SizedBox(height: 4.h),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text:
                        "Create a strong password for your account. Make sure",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray300,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text:
                        "it’s something easy for you to remember, but hard for",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray300,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: "others to guess.",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray300,
                  ),
                ),

                SizedBox(height: 50.h),
                // New Password Field
                CustomTextgray(
                  text: "New Password",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: NewPasswordController,
                    hintText: "Enter your new password",
                    obscureText: !isNewPasswordVisible.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      } else if (!AppString.passRegexp.hasMatch(value)) {
                        return "Password must be at least 8 characters long (A-Z, a-z)";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        isNewPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray200,
                      ),
                      onPressed: () {
                        isNewPasswordVisible.value =
                            !isNewPasswordVisible.value; // Toggle visibility
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Confirm Password
                CustomTextgray(
                  text: "Confirm Password",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: ConfromPasswordController,
                    hintText: "Re-enter your new password",
                    obscureText: !isConformPasswordVisible.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      } else if (value != NewPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConformPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray200,
                      ),
                      onPressed: () {
                        isConformPasswordVisible.value =
                            !isConformPasswordVisible
                                .value; // Toggle visibility
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Send OTP Button
                CustomButton(
                  text: "Reset Password",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.resetPassword(newPassword: NewPasswordController.text);
                    }
                  },
                ),
                SizedBox(height: 20.h),
              ], // Column children
            ), // Column
          ), // SingleChildScrollView
        ), // Padding
      ), // Form
    ); // Scaffold
  } // build
} // SetPassScreen
