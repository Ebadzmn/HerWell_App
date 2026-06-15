import 'package:get/get.dart';

class SettingsController extends GetxController {
  final cycleLength = 28.obs;
  final periodDuration = 5.obs;
  
  final lastPeriodDay = 12.obs;
  final lastPeriodMonth = 'Jun'.obs;
  final lastPeriodYear = 2026.obs;

  final isDarkMode = false.obs;
}
