import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uremz100/core/services/storage_service.dart';
import 'package:uremz100/Data/Repositories/user_profile_repository.dart';
import 'package:uremz100/Features/Auth/Controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final isLoggedIn = false.obs;
  final guestId = "".obs;
  
  final userName = "User".obs;
  final uid = "".obs;

  final _userProfileRepo = Get.put(UserProfileRepo());

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    fetchGuestId();
    if (isLoggedIn.value) {
      fetchUserProfile();
    }
  }

  void checkLoginStatus() {
    final token = Get.find<StorageService>().getToken();
    isLoggedIn.value = token != null && token.isNotEmpty;
  }

  Future<void> fetchGuestId() async {
    final prefs = await SharedPreferences.getInstance();
    guestId.value = prefs.getString('guest_id') ?? "Unknown";
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _userProfileRepo.getUserProfile();
      if (response.isSuccess) {
        final data = response.data;
        if (data is Map && data['data'] != null) {
          final userData = data['data'];
          userName.value = userData['name'] ?? "User";
          uid.value = (userData['id'] ?? userData['_id'] ?? "").toString();
        }
      }
    } catch (e) {
      // Handle error implicitly
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      final response = await _userProfileRepo.deleteAccount(password: password);
      
      Get.back(); // close dialog
      
      if (response.isSuccess) {
        // Show success snackbar
        Get.snackbar(
          "Account Deleted", 
          response.message ?? "Account scheduled for deletion. You can restore it within the recovery window.", 
          snackPosition: SnackPosition.BOTTOM, 
          backgroundColor: const Color(0xFF4CAF50), 
          colorText: const Color(0xFFFFFFFF)
        );
        
        // Log out user
        if (Get.isRegistered<AuthController>()) {
          await Get.find<AuthController>().logout();
        } else {
          final authController = Get.put(AuthController());
          await authController.logout();
        }
      } else {
        Get.snackbar("Error", response.message ?? "Failed to delete account", snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFF44336), colorText: const Color(0xFFFFFFFF));
      }
    } catch (e) {
      Get.back(); // close dialog
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFF44336), colorText: const Color(0xFFFFFFFF));
    }
  }
}
