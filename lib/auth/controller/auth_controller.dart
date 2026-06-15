import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_route.dart';
import '../../core/network/api_client.dart';
import '../models/login_response_model.dart';
import 'dart:convert';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final email = ''.obs;
  final password = ''.obs;
  final otp = ''.obs;

  Future<void> loginUser(String email, String password) async {
    if (isLoading.value) return; // Prevent multiple requests
    try {
      isLoading.value = true;
      
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/auth/login',
        data: {
          "email": email.trim(),
          "password": password,
        },
      );

      if (response.isSuccess && response.data != null) {
        final loginData = LoginResponseModel.fromJson(response.data);
        
        final prefs = await SharedPreferences.getInstance();
        if (loginData.accessToken != null) {
          await prefs.setString('access_token', loginData.accessToken!);
          apiClient.setToken(loginData.accessToken!);
        }
        if (loginData.refreshToken != null) {
          await prefs.setString('refresh_token', loginData.refreshToken!);
        }
        if (loginData.user != null) {
          await prefs.setString('user_data', jsonEncode(loginData.user!.toJson()));
        }

        Get.snackbar('Success', response.message.isNotEmpty ? response.message : 'Login Successful',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1));
            
        final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
        
        if (hasCompletedOnboarding) {
          Get.offAllNamed(AppRoute.navbar);
        } else {
          Get.offAllNamed(AppRoute.onboarding);
        }
      } else {
        Get.snackbar('Error', response.message.isNotEmpty ? response.message : 'Login failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser(String name, String username, String email, String password, String confirmPassword) async {
    if (isLoading.value) return; // Disable multiple submissions
    try {
      isLoading.value = true;
      this.email.value = email;
      
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/auth/register',
        data: {
          "name": name.trim(),
          "username": username.trim(),
          "email": email.trim(),
          "password": password,
          "confirm_password": confirmPassword,
        },
      );

      if (response.isSuccess) {
        Get.snackbar('Success', response.message.isNotEmpty ? response.message : 'Registration Successful',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1));
        Get.offAllNamed(AppRoute.login);
      } else {
        Get.snackbar('Error', response.message.isNotEmpty ? response.message : 'Registration failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
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

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_data');
      
      final ApiClient apiClient = Get.find<ApiClient>();
      apiClient.clearToken();
      
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      Get.snackbar('Error', 'Logout failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
