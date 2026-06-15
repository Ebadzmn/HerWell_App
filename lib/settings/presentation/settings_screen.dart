import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/settings_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_route.dart';
import '../../auth/controller/auth_controller.dart';

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
                        Obx(() => CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFFD49A9B),
                          child: Text(
                            controller.username.value.isNotEmpty
                                ? controller.username.value[0].toUpperCase()
                                : 'M',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )),
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
                      child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.username.value.isNotEmpty
                                ? controller.username.value
                                : 'mxguxnnfbzlenetvlf',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3A2E28),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            controller.email.value.isNotEmpty
                                ? controller.email.value
                                : 'mxguxnnfbzlenetvlf@onidm.net',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8B7355),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )),
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
              GestureDetector(
                onTap: () => _showContraceptionPicker(context),
                child: Obx(() => Container(
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
                          children: [
                            Text(
                              getContraceptionLabel(controller.contraceptionType.value),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
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
                )),
              ),

              const SizedBox(height: 16),

              // Training Goal Card
              Obx(() => Container(
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
                    _buildTrainingGoalItem(
                      'Build strength & muscle',
                      isSelected: controller.fitnessGoal.value == 'build_strength',
                      onTap: () => controller.updateFitnessGoal('build_strength'),
                    ),
                    _buildTrainingGoalItem(
                      'Improve endurance / cardio fitness',
                      isSelected: controller.fitnessGoal.value == 'improve_endurance',
                      onTap: () => controller.updateFitnessGoal('improve_endurance'),
                    ),
                    _buildTrainingGoalItem(
                      'Lose body fat',
                      isSelected: controller.fitnessGoal.value == 'lose_fat',
                      onTap: () => controller.updateFitnessGoal('lose_fat'),
                    ),
                    _buildTrainingGoalItem(
                      'General health & wellbeing',
                      isSelected: controller.fitnessGoal.value == 'general_health',
                      onTap: () => controller.updateFitnessGoal('general_health'),
                    ),
                    _buildTrainingGoalItem(
                      'Athletic performance / competition',
                      isSelected: controller.fitnessGoal.value == 'athletic_performance',
                      onTap: () => controller.updateFitnessGoal('athletic_performance'),
                      isLast: true,
                    ),
                  ],
                ),
              )),

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
      {bool isSelected = false, bool isLast = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
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
      ),
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
          onChangeEnd: (v) {
            controller.updateCycleData();
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
          onChangeEnd: (v) {
            controller.updateCycleData();
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
        GestureDetector(
          onTap: () => _selectStartDate(context),
          child: Row(
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
    ValueChanged<double>? onChangeEnd,
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
        onChangeEnd: onChangeEnd,
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
        Get.put(AuthController()).logout();
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
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoute.deleteAccount);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
      ),
    );
  }

  // Helper integration functions
  String getContraceptionLabel(String type) {
    switch (type) {
      case 'pill':
        return 'Combined Pill';
      case 'mirena':
        return 'Hormonal IUD';
      case 'implant':
        return 'Implant';
      case 'injection':
        return 'Injection';
      case 'mini':
        return 'Mini Pill';
      case 'none':
      default:
        return 'No hormonal contraception';
    }
  }

  void _showContraceptionPicker(BuildContext context) {
    final options = [
      {'id': 'pill', 'title': 'Combined Pill'},
      {'id': 'mirena', 'title': 'Hormonal IUD'},
      {'id': 'implant', 'title': 'Implant'},
      {'id': 'injection', 'title': 'Injection'},
      {'id': 'mini', 'title': 'Mini Pill'},
      {'id': 'none', 'title': 'No hormonal contraception'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Select Contraception Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A2E28),
                ),
              ),
              const Divider(),
              ...options.map((opt) {
                return ListTile(
                  title: Text(
                    opt['title']!,
                    style: const TextStyle(color: Color(0xFF3A2E28)),
                  ),
                  trailing: controller.contraceptionType.value == opt['id']
                      ? const Icon(Icons.check, color: Color(0xFFE8927C))
                      : null,
                  onTap: () {
                    controller.updateContraceptionType(opt['id']!);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final monthMap = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    final monthNum = monthMap[controller.lastPeriodMonth.value] ?? 1;
    final currentDate = DateTime(
      controller.lastPeriodYear.value,
      monthNum,
      controller.lastPeriodDay.value,
    );

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE8927C),
              onPrimary: Colors.white,
              onSurface: Color(0xFF3A2E28),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE8927C),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.lastPeriodDay.value = picked.day;
      controller.lastPeriodMonth.value = DateFormat('MMM').format(picked);
      controller.lastPeriodYear.value = picked.year;
      controller.updateCycleData();
    }
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

