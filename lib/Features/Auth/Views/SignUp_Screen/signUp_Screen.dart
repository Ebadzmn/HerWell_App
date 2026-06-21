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

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController NewPasswordController = TextEditingController();
  final TextEditingController ConfromPasswordController =
      TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Reactive variable to control password visibility
  final isConformPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;

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
                SizedBox(height: 80.h),
                Center(
                  child: Image.asset(
                    AppImages.app_logo,
                    height: 120.w,
                    width: 120.w,
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: CustomTextgray(
                    text: "Sign Up",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Center(
                  child: CustomTextgray(
                    text: "Sign Up to access your travel wise  account",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray300,
                  ),
                ),
                SizedBox(height: 18.h),
                // Email Field
                CustomTextgray(
                  text: "Name",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                Customtextfield(
                  controller: nameController,
                  hintText: "Enter your Full Name",
                  obscureText: false,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    } else if (!AppString.usernameRegexp.hasMatch(value)) {
                      return "Please enter a valid name (3-16 characters)";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18.h),
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
                SizedBox(height: 18.h),
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
                SizedBox(height: 18.h),
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
                SizedBox(height: 18.h),
                // Sign In Button
                CustomButton(
                  text: "Sign Up",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.registerUser(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: NewPasswordController.text,
                      );
                    }
                  },
                ),
                SizedBox(height: 18.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextgray(
                      text: "Already have an account?",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.gray300,
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.signinScreen);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Login Here",
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
                  ],
                ),
                SizedBox(height: 40.h),
              ], // Column children
            ), // Column
          ), // SingleChildScrollView
        ), // Padding
      ), // Form
    ); // Scaffold
  } // build
} // SignupScreen
