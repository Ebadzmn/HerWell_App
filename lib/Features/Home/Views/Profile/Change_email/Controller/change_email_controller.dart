import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Data/Repositories/user_profile_repository.dart';
import 'package:uremz100/Shared/Widgets/Custom_snakbar.dart';

class ChangeEmailController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  
  final _userProfileRepo = Get.find<UserProfileRepo>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> requestEmailChange() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      showCustomSnackBar("Please enter a valid email address", isError: true);
      return;
    }

    if (password.isEmpty) {
      showCustomSnackBar("Please enter your current password", isError: true);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _userProfileRepo.requestEmailChange(
        newEmail: email,
        password: password,
      );

      if (response.isSuccess) {
        showCustomSnackBar(response.message ?? "OTP sent to new email", isError: false);
        Get.toNamed(Routes.forgotOtpScreen, arguments: {
          'flow': 'email_change',
          'email': email,
        });
      } else {
        showCustomSnackBar(response.message ?? "Failed to request email change", isError: true);
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
