import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uremz100/Data/Repositories/user_profile_repository.dart';
import 'package:uremz100/Shared/Widgets/Custom_snakbar.dart';

class ChangeProfileInfoController extends GetxController {
  final nameController = TextEditingController().obs;

  final selectedGender = "Male".obs;
  final genderList = ["Male", "Female", "Other"];

  final selectedDate = "DD.MM.YY".obs;
  
  final isLoading = false.obs;
  final _userProfileRepo = Get.find<UserProfileRepo>();

  void updateGender(String? value) {
    if (value != null) {
      selectedGender.value = value;
    }
  }

  Future<void> chooseDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFF76212),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF76212),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      selectedDate.value = DateFormat('dd.MM.yyyy').format(pickedDate);
    }
  }

  Future<void> updateProfile() async {
    final name = nameController.value.text.trim();
    if (name.isEmpty) {
      showCustomSnackBar("Name cannot be empty", isError: true);
      return;
    }

    if (selectedDate.value == "DD.MM.YY") {
      showCustomSnackBar("Please select a valid date of birth", isError: true);
      return;
    }

    DateTime parsedDate;
    try {
      parsedDate = DateFormat('dd.MM.yyyy').parse(selectedDate.value);
    } catch (e) {
      showCustomSnackBar("Invalid date of birth format", isError: true);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _userProfileRepo.updateProfile(
        name: name,
        gender: selectedGender.value.toUpperCase(),
        dateOfBirth: parsedDate.toUtc().toIso8601String(),
      );

      if (response.isSuccess) {
        showCustomSnackBar("Profile updated successfully", isError: false);
        Get.back();
      } else {
        showCustomSnackBar(response.message ?? "Failed to update profile", isError: true);
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
