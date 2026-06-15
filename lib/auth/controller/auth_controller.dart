import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_route.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final email = ''.obs;
  final password = ''.obs;
  final otp = ''.obs;

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Mock delay
      
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
      
      if (hasCompletedOnboarding) {
        Get.offAllNamed(AppRoute.navbar);
      } else {
        Get.offAllNamed(AppRoute.onboarding);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser(String name, String email, String password) async {
    try {
      isLoading.value = true;
      this.email.value = email;
      await Future.delayed(const Duration(seconds: 1)); // Mock delay
      // Send OTP for registration
      Get.toNamed(AppRoute.signupOtp);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      this.email.value = email;
      await Future.delayed(const Duration(seconds: 1)); // Mock delay
      // Send OTP for forgot password
      Get.toNamed(AppRoute.forgotPasswordOtp);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifySignupOTP(String otp) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Mock delay
      Get.offAllNamed(AppRoute.onboarding);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyForgotPasswordOTP(String otp) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Mock delay
      Get.toNamed(AppRoute.resetPassword);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String newPassword) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Mock delay
      Get.snackbar('Success', 'Password reset successfully', 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE8927C).withOpacity(0.1));
      Get.offAllNamed(AppRoute.login);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> socialLogin(String provider) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Mock delay
      
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
      
      if (hasCompletedOnboarding) {
        Get.offAllNamed(AppRoute.navbar);
      } else {
        Get.offAllNamed(AppRoute.onboarding);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
