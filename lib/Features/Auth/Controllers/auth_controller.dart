import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Data/Repositories/auth_repository.dart';
import '../../../Data/Repositories/user_profile_repository.dart';
import '../../../core/services/storage_service.dart';
import '../../../Config/routes.dart';
import '../../Home/Views/Shorts/Controller/Shorts_Controller.dart';
import '../../Home/Views/Discover/Controller/discover_controller.dart';
import '../../Home/Views/Bottom_NabBar/Controller/Bottom_NabBar_Controller.dart';
import '../../Home/Views/Profile/Controller/profile_controller.dart';
import '../../../core/network/api_exception.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.put(AuthRepository());
  final StorageService _storageService = Get.find<StorageService>();

  final RxBool isLoading = false.obs;

  // Track email during flows
  String registeredEmail = '';
  String forgotPasswordEmail = '';
  String resetToken = ''; // Passed to reset password screen

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _authRepository.registerUser(
        name: name,
        email: email,
        password: password,
      );

      Get.back(); // close dialog

      if (response.isSuccess) {
        registeredEmail = email;
        Get.snackbar("Success", response.message ?? "User created successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        // Navigate to OTP Screen
        Get.toNamed(Routes.forgotOtpScreen, arguments: {'flow': 'register', 'email': email});
      } else {
        Get.snackbar("Error", response.message ?? "Registration failed", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back(); // close dialog
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String flow,
  }) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      // If the API for verifyOtp is only for registration, and forgot password uses another API, 
      // but according to the docs, verify-otp might return a resetToken if it's forgot password flow?
      // Wait, the doc says: "After OTP verification, the backend issues a temporary reset token. API POST /api/v1/auth/reset-password Headers: Authorization: Bearer <resetToken>".
      // This implies verifyOtp returns the reset token in the data.
      
      dynamic response;
      if (flow == 'email_change') {
        response = await Get.find<UserProfileRepo>().confirmEmailChange(otp: otp);
      } else {
        response = await _authRepository.verifyOtp(email: email, otp: otp);
      }

      Get.back();

      if (response.isSuccess) {
        Get.snackbar("Success", response.message ?? "Email verified successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        
        if (flow == 'register') {
           // Go to login or just show dialog and stay
           Get.offAllNamed(Routes.signinScreen);
        } else if (flow == 'forgot_password') {
           // Save reset token from response data (assuming it's returned like this)
           if (response.data is Map && response.data['resetToken'] != null) {
              resetToken = response.data['resetToken'];
           } else if (response.data is Map && response.data['data'] != null && response.data['data']['resetToken'] != null) {
              resetToken = response.data['data']['resetToken'];
           }
           Get.toNamed(Routes.setPassScreen);
        } else if (flow == 'email_change') {
           // Clear session completely and navigate to login
           await _storageService.clearToken();
           await _storageService.clearRefreshToken();
           final prefs = await SharedPreferences.getInstance();
           final uuid = Uuid();
           final newGuestId = 'guest-${uuid.v4()}';
           await prefs.setString('guest_id', newGuestId);
           
           Get.offAllNamed(Routes.signinScreen);
        }
      } else {
        Get.snackbar("Error", response.message ?? "OTP Verification failed", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _authRepository.login(email: email, password: password);

      Get.back();

      if (response.isSuccess) {
        final data = response.data;
        if (data is Map && data['data'] != null) {
           final tokens = data['data']; 
           if (tokens['accessToken'] != null) {
             await _storageService.saveToken(tokens['accessToken']);
           }
           if (tokens['refreshToken'] != null) {
             await _storageService.saveRefreshToken(tokens['refreshToken']);
           }
        }

        // Hide login popups from any open controllers
        try {
          if (Get.isRegistered<ShortsController>()) {
             Get.find<ShortsController>().showLoginPopup.value = false;
          }
          if (Get.isRegistered<DiscoverController>()) {
             Get.find<DiscoverController>().showLoginPopup.value = false;
          }
        } catch (e) {}

        Get.offAllNamed(Routes.bottomNabbarScreens);
      } else {
        Get.snackbar("Error", response.message ?? "Login failed", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      if (e is ApiException && e.statusCode == 403 && e.message.contains("Your account has been deleted")) {
        Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xFF121212),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Account Deleted", style: TextStyle(color: Colors.white)),
            content: const Text("Your account is currently deleted. Would you like to restore it?", style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  restoreAccount(email: email, password: password);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
                child: const Text("Yes, Restore", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restoreAccount({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _authRepository.restoreAccount(email: email, password: password);

      Get.back();

      if (response.isSuccess) {
        final data = response.data;
        if (data is Map && data['data'] != null) {
           final tokens = data['data']; 
           if (tokens['accessToken'] != null) {
             await _storageService.saveToken(tokens['accessToken']);
           }
           if (tokens['refreshToken'] != null) {
             await _storageService.saveRefreshToken(tokens['refreshToken']);
           }
        }

        // Hide login popups from any open controllers
        try {
          if (Get.isRegistered<ShortsController>()) {
             Get.find<ShortsController>().showLoginPopup.value = false;
          }
          if (Get.isRegistered<DiscoverController>()) {
             Get.find<DiscoverController>().showLoginPopup.value = false;
          }
        } catch (e) {}

        // Fetch profile and navigate
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().checkLoginStatus();
          await Get.find<ProfileController>().fetchUserProfile();
        } else {
          final profileCtrl = Get.put(ProfileController());
          profileCtrl.checkLoginStatus();
          await profileCtrl.fetchUserProfile();
        }

        Get.snackbar("Success", response.message ?? "Account restored successfully.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed(Routes.bottomNabbarScreens);
      } else {
        Get.snackbar("Error", response.message ?? "Failed to restore account", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _authRepository.forgotPassword(email: email);

      Get.back();

      if (response.isSuccess) {
        forgotPasswordEmail = email;
        Get.snackbar("Success", response.message ?? "OTP sent to your email", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        Get.toNamed(Routes.forgotOtpScreen, arguments: {'flow': 'forgot_password', 'email': email});
      } else {
        Get.snackbar("Error", response.message ?? "Failed to send OTP", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({required String newPassword}) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _authRepository.resetPassword(
         resetToken: resetToken, 
         newPassword: newPassword,
      );

      Get.back();

      if (response.isSuccess) {
        Get.snackbar("Success", response.message ?? "Password reset successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed(Routes.signinScreen);
      } else {
        Get.snackbar("Error", response.message ?? "Failed to reset password", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _authRepository.changePassword(
        currentPassword: currentPassword, 
        newPassword: newPassword,
      );

      Get.back();

      if (response.isSuccess) {
        Get.snackbar("Success", response.message ?? "Password changed successfully", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        Get.back(); // Go back from change password screen
      } else {
        Get.snackbar("Error", response.message ?? "Failed to change password", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearToken();
    await _storageService.clearRefreshToken();
    
    // Generate a new guest ID to completely reset session
    final prefs = await SharedPreferences.getInstance();
    const uuid = Uuid();
    final newGuestId = 'guest-${uuid.v4()}';
    await prefs.setString('guest_id', newGuestId);

    if (Get.isRegistered<NavigationController>()) {
      Get.find<NavigationController>().changeIndex(0);
    }
    Get.offAllNamed(Routes.bottomNabbarScreens, arguments: 0);
  }
}
