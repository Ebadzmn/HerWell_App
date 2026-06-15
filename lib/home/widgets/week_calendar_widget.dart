import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../controller/home_controller.dart';

class WeekCalendarWidget extends StatelessWidget {
  const WeekCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final day = startOfWeek.add(Duration(days: index));
          final dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
          final isToday = day.year == now.year && day.month == now.month && day.day == now.day;

          return GestureDetector(
            onTap: () => controller.selectDate(day),
            child: Obx(() {
              final isSelected = controller.selectedDate.value.year == day.year &&
                               controller.selectedDate.value.month == day.month &&
                               controller.selectedDate.value.day == day.day;
              
              return Column(
                children: [
                  Text(
                    isToday ? 'TODAY' : dayNames[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: isToday ? Colors.white : Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      shape: BoxShape.circle,
                      boxShadow: isSelected 
                        ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
                        : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFF5A4D42) : Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Indicator dot placeholder (React app has phase dots here)
                  Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      color: Colors.transparent, // Update this when we have log data
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              );
            }),
          );
        }),
      ),
    );
  }
}
