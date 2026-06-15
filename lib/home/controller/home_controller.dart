import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var currentPhase = 'Follicular'.obs;
  var cycleDay = 8.obs;
  var cycleLength = 28.obs;
  var periodStartDate = DateTime.now().subtract(const Duration(days: 7)).obs;

  @override
  void onInit() {
    super.onInit();
    calculatePhase();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    calculatePhase();
  }

  void calculatePhase() {
    final difference = selectedDate.value.difference(periodStartDate.value).inDays;
    cycleDay.value = (difference % cycleLength.value) + 1;
    currentPhase.value = getPhaseForDate(selectedDate.value);
  }

  String getPhaseForDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    final difference = targetDate.difference(periodStartDate.value).inDays;
    final dayInCycle = (difference % cycleLength.value) + 1;

    if (dayInCycle <= 5) {
      if (targetDate.isAfter(today)) {
        return 'Predicted period';
      }
      return 'Menstruation';
    } else if (dayInCycle <= 13) {
      return 'Follicular';
    } else if (dayInCycle <= 16) {
      return 'Ovulation';
    } else {
      return 'Luteal';
    }
  }

  int getDayInCycleForDate(DateTime date) {
    final difference = date.difference(periodStartDate.value).inDays;
    return (difference % cycleLength.value) + 1;
  }

  void updateCycleData({DateTime? startDate, int? length}) {
    if (startDate != null) periodStartDate.value = startDate;
    if (length != null) cycleLength.value = length;
    calculatePhase();
  }

  int getPhaseNumber() {
    final day = getDayInCycleForDate(selectedDate.value);
    if (day <= 5) return 1;
    if (day <= 13) return 2;
    if (day <= 16) return 3;
    return 4;
  }

  Color getPhaseColor(String phase) {
    switch (phase) {
      case 'Menstruation':
        return const Color(0xFFFFD1D1);
      case 'Predicted period':
        return const Color(0xFFFFEBEB);
      case 'Follicular':
        return const Color(0xFFFFF4D1);
      case 'Ovulation':
        return const Color(0xFFD1F9ED);
      case 'Luteal':
        return const Color(0xFFE8D1FF);
      default:
        return Colors.transparent;
    }
  }
}
