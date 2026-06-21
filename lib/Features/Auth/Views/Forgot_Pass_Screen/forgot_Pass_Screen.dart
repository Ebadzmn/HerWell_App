import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_AppBar.dart';
import 'package:uremz100/Shared/Widgets/Custom_Button.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Field.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Gray.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_consts.dart';
import 'package:uremz100/Utils/app_images.dart';
import '../../Controllers/auth_controller.dart';

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    AppImages.forgot_image,
                    height: 250.w,
                    width: 250.w,
                  ),
                ),
                SizedBox(height: 24.h),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: "Forgot Your Password?",
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
                        "Enter your registered email address to receive a one-",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray300,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: "time password (OTP) and securely reset your",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray300,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: "password.",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray300,
                  ),
                ),

                SizedBox(height: 50.h),
                // Email Field
                CustomTextgray(
                  text: "Email",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: emailController,
                  hintText: "mdibukholil@gmail.com",
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!AppString.emailRegexp.hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                // Send OTP Button
                CustomButton(
                  text: "Send OTP",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.forgotPassword(email: emailController.text.trim());
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
} // ForgotPassScreen
