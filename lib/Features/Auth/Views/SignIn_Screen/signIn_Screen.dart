import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Button.dart';
import 'package:uremz100/Shared/Widgets/Custom_Button_Icon.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Field.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Gray.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_consts.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'package:uremz100/Utils/app_images.dart';
import '../../Controllers/auth_controller.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Reactive variable to control password visibility
  final isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black100,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: Image.asset(
                    AppImages.app_logo,
                    height: 120.w,
                    width: 120.w,
                  ),
                ),
                SizedBox(height: 14.h),
                Center(
                  child: CustomTextgray(
                    text: "Sign in to continue watching",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
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
                SizedBox(height: 16.h),
                // Password Field
                CustomTextgray(
                  text: "Password",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Customtextfield(
                    controller: passwordController,
                    hintText: "Enter your password",
                    obscureText: !isPasswordVisible.value,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.gray200,
                      ),
                      onPressed: () {
                        isPasswordVisible.value =
                            !isPasswordVisible.value; // Toggle visibility
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.forgotPassScreen);
                    },
                    child: CustomTextgray(
                      text: "Forget Password?",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                // Sign In Button
                CustomButton(
                  text: "Sign in",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.login(
                        email: emailController.text.trim(), 
                        password: passwordController.text,
                      );
                    }
                  },
                ),
                SizedBox(height: 18.h),

                SizedBox(height: 45.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextgray(
                      text: "Don’t have an account?",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.gray300,
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.signupScreen);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sign Up Here",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFC727),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: 72.w, // underline এর width
                            color: Color(0xFFFFC727),
                          ),
                        ],
                      ),
                    ),
                  ], // Row children
                ), // Row
              ], // Column children
            ), // Column
          ), // SingleChildScrollView
        ), // Padding
      ), // Form
    ); // Scaffold
  } // build
} // SigninScreen
