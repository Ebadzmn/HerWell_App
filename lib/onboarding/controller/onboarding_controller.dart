import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_route.dart';
import '../../core/network/api_client.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;

class OnboardingController extends GetxController {
  var currentStep = 1.obs;
  final int totalSteps = 9;

  // UI State
  final isLoading = RxBool(false);

  // Auth Data (Local UI only)
  final email = RxString('');
  final password = RxString('');

  // Form Data
  final profilePicture = RxnString();
  final contraception = RxnString();
  final pillType = RxnString();
  final pillProgestogen = RxnString();
  final pillFreeWeek = RxnBool(true);
  final iudPeriod = RxnString();
  final iudOvulating = Rxn<dynamic>();
  final implantBleed = RxnString();
  final implantPattern = RxnBool();
  final injectionBleed = RxnString();
  final miniType = RxnString();
  final miniOvulating = RxnBool();
  
  final cycleRegular = RxBool(true);
  final alreadyTracking = RxnString();
  final cycleLength = RxInt(28);
  final periodLength = RxInt(5);
  final lastDay = RxnInt();
  final lastMonth = RxnInt();
  final lastYear = RxnInt(DateTime.now().year);
  
  final trackingMethod = RxnString();
  final dailyCheckins = <String>['Sleep quality', 'Energy level', 'Training performance', 'Mood & motivation'].obs;
  final selectedSymptoms = <String>[].obs;
  final fitnessGoal = RxString('build_muscle');

  // Dynamic backend-seeded options
  final dbContraceptions = <Map<String, dynamic>>[].obs;
  final dbGoals = <Map<String, dynamic>>[].obs;
  final dbSymptoms = <String>[].obs;
  final dbDailyCheckins = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOnboardingOptions();
  }

  Future<void> loadOnboardingOptions() async {
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.get('/onboarding/options');
      if (response.isSuccess && response.data != null) {
        final data = response.data;
        if (data['contraceptions'] != null) {
          dbContraceptions.value = List<Map<String, dynamic>>.from(data['contraceptions']);
        }
        if (data['goals'] != null) {
          dbGoals.value = List<Map<String, dynamic>>.from(data['goals']);
        }
        if (data['symptoms'] != null) {
          dbSymptoms.value = List<String>.from((data['symptoms'] as List).map((s) => s['name'] as String));
        }
        if (data['checkins'] != null) {
          dbDailyCheckins.value = List<Map<String, dynamic>>.from(data['checkins']);
        }
      }
    } catch (e) {
      debugPrint("Failed to load onboarding options: $e");
    }
  }

  void nextStep() {
    if (currentStep.value < totalSteps) {
      currentStep.value++;
    } else {
      completeOnboarding();
    }
  }

  void prevStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  Future<void> completeOnboarding() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;

      final ApiClient apiClient = Get.find<ApiClient>();

      // 1. Upload profile photo if chosen
      String? avatarUrl;
      if (profilePicture.value != null && profilePicture.value!.isNotEmpty) {
        try {
          final file = File(profilePicture.value!);
          if (await file.exists()) {
            final fileName = file.path.split('/').last;
            final formData = dio.FormData.fromMap({
              'file': await dio.MultipartFile.fromFile(file.path, filename: fileName),
            });
            final uploadResponse = await apiClient.post(
              '/integration/files/upload',
              data: formData,
            );
            if (uploadResponse.isSuccess && uploadResponse.data != null) {
              avatarUrl = uploadResponse.data['file_url'];
            }
          }
        } catch (e) {
          debugPrint("Failed to upload profile picture: $e");
        }
      }

      // 2. Update user profile with avatar URL if uploaded
      if (avatarUrl != null) {
        try {
          await apiClient.put('/auth/me', data: {"avatarUrl": avatarUrl});
        } catch (e) {
          debugPrint("Failed to update avatarUrl on user: $e");
        }
      }

      final now = DateTime.now();
      final year = lastYear.value ?? now.year;
      final month = lastMonth.value ?? now.month;
      final day = lastDay.value ?? now.day;
      final startDateStr = "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

      final response = await apiClient.post(
        '/cycle/cycle-data',
        data: {
          "cycle_start_date": startDateStr,
          "cycle_length": cycleLength.value,
          "period_length": periodLength.value,
          "fitness_goal": fitnessGoal.value,
          "contraception_type": contraception.value ?? "none",
          "tracking_method": trackingMethod.value ?? "calendar",
          "pill_progestogen": pillProgestogen.value,
          "cycle_regular": cycleRegular.value,
          "symptoms": selectedSymptoms.toList(),
          "daily_checkins": dailyCheckins.toList(),
          "preferred_workout_types": [],
          "available_equipment": [],
        },
      );

      if (response.isSuccess) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasCompletedOnboarding', true);
        Get.offAllNamed(AppRoute.navbar);
      } else {
        Get.snackbar(
          'Error',
          response.message.isNotEmpty ? response.message : 'Failed to save onboarding data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred during onboarding completion',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    isLoading.value = false;
    nextStep();
  }

  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    isLoading.value = false;
    Get.offAllNamed(AppRoute.navbar);
  }

  void toggleSymptom(String symptom) {
    if (selectedSymptoms.contains(symptom)) {
      selectedSymptoms.remove(symptom);
    } else {
      selectedSymptoms.add(symptom);
    }
  }

  int getPhaseNumber() {
    return 1;
  }
}
