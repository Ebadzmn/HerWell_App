import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';

class WorkoutsController extends GetxController {
  var selectedTab = 0.obs;
  var selectedIntensity = 'all'.obs;
  var selectedDuration = 'all'.obs;
  var selectedBodypart = 'all'.obs;

  final intensities = ['all', 'low', 'moderate', 'high'];
  final durations = [
    {'value': 'all', 'label': 'Any duration'},
    {'value': '15-30', 'label': '15–30 min'},
    {'value': '30-45', 'label': '30–45 min'},
    {'value': '45-60', 'label': '45–60 min'},
    {'value': '60+', 'label': '60+ min'},
  ];
  final bodyparts = ['all', 'full body', 'lower body', 'upper body', 'core', 'glutes', 'back', 'cardio', 'mobility'];

  @override
  void onInit() {
    super.onInit();
    _setDefaultsByPhase();
  }

  void _setDefaultsByPhase() {
    final homeController = Get.find<HomeController>();
    final phase = homeController.currentPhase.value.toLowerCase();
    
    if (phase.contains('menstruat')) {
      selectedIntensity.value = 'low';
    } else if (phase.contains('follicular') || phase.contains('ovulat')) {
      selectedIntensity.value = 'high';
    } else {
      selectedIntensity.value = 'moderate';
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
