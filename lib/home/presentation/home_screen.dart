import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../widgets/header_widget.dart';
import '../widgets/week_calendar_widget.dart';
import '../widgets/today_section_widget.dart';
import '../widgets/phase_indicator_widget.dart';
import '../widgets/daily_logger_widget.dart';
import '../widgets/tips_section_widget.dart';
import '../widgets/hormone_chart_widget.dart';
import '../widgets/symptom_logger_widget.dart';
import '../widgets/phase_explorer_widget.dart';
import '../widgets/cycle_references_widget.dart';
import '../widgets/cycle_pattern_insights_widget.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColors.background;
    
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top Section with Gradient and Curves
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark ? [
                        const Color(0xFF2C2C2C),
                        const Color(0xFF1E1E1E),
                        const Color(0xFF121212),
                      ] : [
                        AppColors.homeGradientStart,
                        AppColors.homeGradientMid,
                        AppColors.homeGradientEnd,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: const [
                        HeaderWidget(),
                        WeekCalendarWidget(),
                        PhaseIndicatorWidget(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Decorative Curves
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.2,
                      child: CustomPaint(
                        painter: CurvePainter(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content Section
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TodaySectionWidget(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          DailyLoggerWidget(),
                          SizedBox(height: 16),
                          CyclePatternInsightsWidget(),
                          SizedBox(height: 16),
                          SymptomLoggerWidget(),
                          SizedBox(height: 16),
                          HormoneChartWidget(),
                          SizedBox(height: 16),
                          PhaseExplorerWidget(),
                          SizedBox(height: 16),
                          CycleReferencesWidget(),
                        ],
                      ),
                    ),
                    TipsSectionWidget(),
                    SizedBox(height: 100), // bottom nav padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.2);
    path1.quadraticBezierTo(size.width * 0.25, size.height * 0.25, size.width * 0.5, size.height * 0.2);
    path1.quadraticBezierTo(size.width * 0.75, size.height * 0.15, size.width, size.height * 0.2);
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.4);
    path2.quadraticBezierTo(size.width * 0.375, size.height * 0.45, size.width * 0.75, size.height * 0.4);
    path2.quadraticBezierTo(size.width * 0.875, size.height * 0.375, size.width, size.height * 0.4);
    canvas.drawPath(path2, paint);

    final path3 = Path();
    path3.moveTo(0, size.height * 0.6);
    path3.quadraticBezierTo(size.width * 0.25, size.height * 0.65, size.width * 0.5, size.height * 0.6);
    path3.quadraticBezierTo(size.width * 0.75, size.height * 0.55, size.width, size.height * 0.6);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
