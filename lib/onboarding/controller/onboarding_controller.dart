import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_route.dart';

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
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Mock delay for UI feel
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    isLoading.value = false;
    // After onboarding, go to home screen as requested
    Get.offAllNamed(AppRoute.navbar);
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
