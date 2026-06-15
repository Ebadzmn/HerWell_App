import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/settings_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_route.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: const Color(0xFFE3D6C9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF3A2E28),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your profile and preferences',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8B7355),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Profile Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFFD49A9B),
                          child: Text(
                            'm',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8927C),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.settings,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'mxguxnnfbzlenetvlf',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3A2E28),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'mxguxnnfbzlenetvlf@onidm.net',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8B7355),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CYCLE PROFILE
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'CYCLE PROFILE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8B7355),
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              // Contraception Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('💊', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Combined Pill',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Contraception type',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFA09FA6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Text(
                          'EDIT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE8927C),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFFE8927C),
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Training Goal Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Training Goal',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF3A2E28),
                        ),
                      ),
                    ),
                    _buildTrainingGoalItem('Build strength & muscle',
                        isSelected: true),
                    _buildTrainingGoalItem('Improve endurance / cardio fitness'),
                    _buildTrainingGoalItem('Lose body fat'),
                    _buildTrainingGoalItem('General health & wellbeing'),
                    _buildTrainingGoalItem('Athletic performance / competition',
                        isLast: true),
                  ],
                ),
              ),

              const SizedBox(height: 16),


              // Cycle Length Card
              Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildExpandedCycleCard(isDark),
              )),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'SUBSCRIPTION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8B7355),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              _buildSubscriptionCard(),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'APP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8B7355),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              _buildAppCard(),
              const SizedBox(height: 24),
              _buildSignOutButton(),
              const SizedBox(height: 16),
              _buildDeleteAccountButton(),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'HerWellness · Version 1.0 · yasmin@herwellness.app',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9287),
                  ),
                ),
              ),
              const SizedBox(height: 80), // Padding for Bottom Nav Bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingGoalItem(String title,
      {bool isSelected = false, bool isLast = false}) {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1, color: Color(0xFFF6F3F0)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF3A2E28)
                        : const Color(0xFF9E9287),
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check,
                  size: 18,
                  color: Color(0xFFE8927C),
                ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildExpandedCycleCard(bool isDark) {
    final titleColor = isDark ? Colors.white : const Color(0xFF3A2E28);
    final boxBgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF3EFEA);
    final boxBorderColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE2D6C8);
    final boxTextColor = isDark ? Colors.white : const Color(0xFF2D2420);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle Length',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${controller.cycleLength.value} ',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE8927C),
                    fontFamily: 'Georgia',
                  ),
                ),
                const TextSpan(
                  text: 'days',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE8927C),
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildCustomSlider(
          value: controller.cycleLength.value.toDouble(),
          min: 21,
          max: 40,
          onChanged: (v) {
            controller.cycleLength.value = v.toInt();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('21', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
              Text('28', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
              Text('35', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
              Text('40+', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 32),

        Text(
          'Period Duration',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${controller.periodDuration.value} ',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE8927C),
                    fontFamily: 'Georgia',
                  ),
                ),
                const TextSpan(
                  text: 'days',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE8927C),
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildCustomSlider(
          value: controller.periodDuration.value.toDouble(),
          min: 1,
          max: 10,
          onChanged: (v) {
            controller.periodDuration.value = v.toInt();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('1', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
              Text('3', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
              Text('5', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
              Text('7', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
              Text('10', style: TextStyle(color: Color(0xFFAAA5A0), fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 32),

        Text(
          'Last Period Start Date',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: boxBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: boxBorderColor, width: 1),
                ),
                child: Text(
                  '${controller.lastPeriodDay.value}',
                  style: TextStyle(fontSize: 16, color: boxTextColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: boxBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: boxBorderColor, width: 1),
                ),
                child: Text(
                  controller.lastPeriodMonth.value,
                  style: TextStyle(fontSize: 16, color: boxTextColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: boxBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: boxBorderColor, width: 1),
                ),
                child: Text(
                  '${controller.lastPeriodYear.value}',
                  style: TextStyle(fontSize: 16, color: boxTextColor),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCustomSlider({
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        activeTrackColor: const Color(0xFFE8927C),
        inactiveTrackColor: const Color(0xFFDCDCE2),
        thumbColor: const Color(0xFF7B8089),
        overlayColor: const Color(0xFFE8927C).withOpacity(0.1),
        thumbShape: _CustomThumbShape(),
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
  Widget _buildSubscriptionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFFE8927C), Color(0xFFA687C6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Premium Cycle Insights',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Start your 7-day free trial — cancel anytime.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          // Features
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPremiumFeature('Advanced hormone trend charts'),
                const SizedBox(height: 12),
                _buildPremiumFeature('Phase-optimised workout plans'),
                const SizedBox(height: 12),
                _buildPremiumFeature('AI nutrition guidance'),
                const SizedBox(height: 12),
                _buildPremiumFeature('Symptom pattern insights'),
              ],
            ),
          ),
          // Pricing Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildPricingCard(
                    title: 'Annual',
                    price: '£115.99',
                    suffix: '/year',
                    subtitle: '≈ £9.67/month · Save 19%',
                    isBestValue: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPricingCard(
                    title: 'Monthly',
                    price: '£11.99',
                    suffix: '/month',
                    subtitle: '',
                    isBestValue: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // CTA Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8927C), Color(0xFFA687C6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Start 7-Day Free Trial',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No charge for 7 days · Cancel anytime in App Store',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF8B7355),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPremiumFeature(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: Color(0xFFE8927C), size: 16),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF3A2E28),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required String suffix,
    required String subtitle,
    required bool isBestValue,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isBestValue ? const Color(0xFFFAF5F0) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isBestValue ? const Color(0xFFE8927C) : const Color(0xFFE2D6C8),
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF3A2E28)),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A2E28),
                      ),
                    ),
                    TextSpan(
                      text: suffix,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF8B7355),
                      ),
                    ),
                  ],
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF8B7355),
                  ),
                ),
              ]
            ],
          ),
        ),
        if (isBestValue)
          Positioned(
            top: -8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFA687C6), // Light purple
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Best Value',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAppCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildAppSettingItem(
            icon: Icons.light_mode_outlined,
            iconBgColor: const Color(0xFFF3EFEA),
            iconColor: const Color(0xFF3A2E28),
            title: 'Appearance',
            isToggle: true,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF6F3F0)),
          _buildAppSettingItem(
            icon: Icons.notifications_off_outlined,
            iconBgColor: const Color(0xFFFFF0EC),
            iconColor: const Color(0xFFE8927C),
            title: 'Notifications: Off',
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF6F3F0)),
          _buildAppSettingItem(
            icon: Icons.privacy_tip_outlined,
            iconBgColor: const Color(0xFFF4F0F9),
            iconColor: const Color(0xFFA687C6),
            title: 'Privacy & Data',
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    bool isToggle = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3A2E28),
              ),
            ),
          ),
          if (isToggle)
            Obx(() => Switch(
                  value: controller.isDarkMode.value,
                  onChanged: (val) {
                    controller.isDarkMode.value = val;
                    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  },
                  activeColor: const Color(0xFFE8927C),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE2D6C8),
                ))
          else
            const Icon(Icons.chevron_right, color: Color(0xFFC4B8AD), size: 20),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return InkWell(
      onTap: () {
        Get.offAllNamed(AppRoute.login);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: Color(0xFFC0473A), size: 18),
            SizedBox(width: 8),
            Text(
              'Sign out',
              style: TextStyle(
                color: Color(0xFFC0473A),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCDBEAE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.delete_outline, color: Color(0xFFC0473A), size: 18),
          SizedBox(width: 8),
          Text(
            'Delete account',
            style: TextStyle(
              color: Color(0xFFC0473A),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(20, 20);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    
    // Outer white border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Inner thumb color
    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? const Color(0xFF7B8089)
      ..style = PaintingStyle.fill;
      
    // Shadow
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: center, radius: 10)),
      Colors.black,
      2.0,
      true,
    );

    // Draw border
    canvas.drawCircle(center, 10, borderPaint);
    // Draw inner
    canvas.drawCircle(center, 7.5, thumbPaint);
  }
}

