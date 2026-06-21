import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Shared/Widgets/Custom_AppBar.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text_Field.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_consts.dart';
import '../../../../Auth/Controllers/auth_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Change Password", showBackButton: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              CustomText(
                text: "Change Password",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB4B9BF),
              ),
              SizedBox(height: 15.h),

              // Old Password
              _buildLabel("Old Password"),
              SizedBox(height: 8.h),
              Customtextfield(
                controller: _oldPasswordController,
                hintText: "Enter Old Password",
                obscureText: true,
                textInputType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your old password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 14.h),

              // New Password
              _buildLabel("New Password"),
              SizedBox(height: 8.h),
              Customtextfield(
                controller: _newPasswordController,
                hintText: "Enter New Password",
                obscureText: true,
                textInputType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a new password";
                  } else if (!AppString.passRegexp.hasMatch(value)) {
                    return "Password must be at least 8 characters long (A-Z, a-z)";
                  }
                  return null;
                },
              ),
              SizedBox(height: 14.h),

              // Confirm Password
              _buildLabel("Confirm Password"),
              SizedBox(height: 8.h),
              Customtextfield(
                controller: _confirmPasswordController,
                hintText: "Enter Confirm Password",
                obscureText: true,
                textInputType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  } else if (value != _newPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),

              SizedBox(height: 200.h),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _authController.changePassword(
                        currentPassword: _oldPasswordController.text,
                        newPassword: _newPasswordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                  ),
                  child: CustomText(
                    text: "Save",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
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
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return CustomText(text: text, fontSize: 14.sp, fontWeight: FontWeight.w400);
  }
}
