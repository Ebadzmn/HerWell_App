import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_AppBar.dart';
import 'package:uremz100/Shared/Widgets/Custom_Button.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Gray.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_consts.dart';
import 'package:uremz100/Utils/app_images.dart';
import '../../Controllers/auth_controller.dart';

class ForgotOtpScreen extends StatelessWidget {
  ForgotOtpScreen({super.key});
  final pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 40.w,
      height: 40.w,
      textStyle: GoogleFonts.inter(
        fontSize: 14.sp,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.white100,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.black100,
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
                    height: 230.w,
                    width: 230.w,
                  ),
                ),
                SizedBox(height: 24.h),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: "OTP Sent To Your E-Mail",
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
                        "We’ve sent a 6-digit code to your registered E-MAIL.",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray300,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text:
                        "Enter it below to verify your identity and reset your",
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
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: "We've Sent a Code to your email",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white100,
                  ),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.center,
                  child: Pinput(
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    controller: pinController,

                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColors.red100, width: 1),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: AppColors.white100,
                        border: Border.all(color: Colors.transparent),
                      ),
                    ),
                    onCompleted: (pin) => debugPrint(pin),
                    validator: (value) {
                      // Null check
                      if (value == null || value.isEmpty) {
                        return 'Enter OTP';
                      }
                      // 6 digit check
                      if (value.length < 6) {
                        return 'Enter 6 digit OTP';
                      }
                      // Only number check
                      if (!AppString.otpRegexp.hasMatch(value)) {
                        return 'Enter Only number';
                      }
                      return null;
                    },
                    // all field validation
                    forceErrorState: true,
                    errorTextStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextgray(
                      text: "If you didn’t receive a code.",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.gray300,
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        // Get.toNamed(Routes.signupScreen);
                      },
                      child: CustomTextgray(
                        text: " Resend",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFC727),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Send OTP Button
                CustomButton(
                  text: "Submit OTP",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final args = Get.arguments as Map<String, dynamic>?;
                      final flow = args?['flow'] ?? 'register';
                      final email = args?['email'] ?? '';
                      _authController.verifyOtp(email: email, otp: pinController.text, flow: flow);
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
} // ForgotOtpScreen
