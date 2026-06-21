import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Features/Home/Views/Rewards/Controller/rewards_controller.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_icons.dart';

class DailyBonusPopup extends StatelessWidget {
  final VoidCallback onClose;
  const DailyBonusPopup({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    // We use RewardsController to keep streak in sync with Rewards page
    final controller = Get.put(RewardsController());

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 25.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFB3651C).withOpacity(0.5),
                        const Color(0xFF000000).withOpacity(0.5),
                        const Color(0xFF000000),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: const [0.0, 0.4, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: const Color(0xFFAE5F19).withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: "Claim Daily Bonus, Unlock\nNew Episodes.",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20.h),
                      Obx(() => Column(
                        children: [
                          Row(
                            children: List.generate(4, (index) {
                              bool isChecked = controller.checkedInDays[index + 1] ?? false;
                              bool isToday = index == controller.currentStreak.value;
                              int coinAmount = controller.streakRewards[index];

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: index < 3 ? 10.w : 0),
                                  child: _buildBonusCard(index, coinAmount, isChecked, isToday, false),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: _buildBonusCard(4, controller.streakRewards[4], controller.checkedInDays[5] ?? false, 4 == controller.currentStreak.value, false),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: _buildBonusCard(5, controller.streakRewards[5], controller.checkedInDays[6] ?? false, 5 == controller.currentStreak.value, false),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildBonusCard(6, controller.streakRewards[6], controller.checkedInDays[7] ?? false, 6 == controller.currentStreak.value, true),
                              ),
                            ],
                          ),
                        ],
                      )),
                      SizedBox(height: 20.h),
                      Obx(() => GestureDetector(
                        onTap: controller.canCheckIn.value 
                            ? () { controller.claimDailyCheckIn(); } 
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: controller.canCheckIn.value 
                                ? const Color(0xFFF76212) 
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: CustomText(
                              text: controller.canCheckIn.value 
                                  ? "Check-In" 
                                  : "Available in ${controller.checkInRemainingTime.value}",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 45.w,
                top: 65.h,
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: EdgeInsets.all(5.w),
                    child: Icon(Icons.close, color: Colors.white, size: 24.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBonusCard(int index, int coinAmount, bool isChecked, bool isToday, bool isWide) {
    bool isLastDay = index == 6;

    Gradient? cardGradient;
    if (isToday) {
      cardGradient = const LinearGradient(
        colors: [Color(0xFFF76212), Color(0xFFD64D0B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (isChecked) {
      cardGradient = LinearGradient(
        colors: [const Color(0xFFF76212).withOpacity(0.2), const Color(0xFFF76212).withOpacity(0.05)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      cardGradient = const LinearGradient(
        colors: [Color(0xFF2C2D35), Color(0xFF1E1F25)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isToday 
              ? const Color(0xFFFFB085) // Bright border for today
              : isChecked 
                  ? const Color(0xFFF76212).withOpacity(0.4)
                  : Colors.white.withOpacity(0.08),
          width: isToday ? 1.5 : 1,
        ),
        boxShadow: isToday ? [
          BoxShadow(
            color: const Color(0xFFF76212).withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLastDay 
                ? Icon(Icons.card_giftcard, color: isToday ? Colors.white : (isChecked ? const Color(0xFFF76212) : const Color(0xFF8E8E8E)), size: isWide ? 34.sp : 26.sp)
                : SvgPicture.asset(
                    AppIcons.rewards__rank_icon,
                    height: isWide ? 30.w : 22.w,
                    width: isWide ? 30.w : 22.w,
                    colorFilter: (isToday || isChecked) ? null : const ColorFilter.mode(Color(0xFF8E8E8E), BlendMode.srcIn),
                  ),
              SizedBox(height: 6.h),
              CustomText(
                text: "+$coinAmount",
                fontSize: isToday ? 15.sp : 13.sp,
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w700,
                color: isToday ? Colors.white : (isChecked ? const Color(0xFFF76212) : const Color(0xFF8E8E8E)),
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: "Day ${index + 1}",
                fontSize: 11.sp,
                color: isToday ? Colors.white.withOpacity(0.9) : (isChecked ? Colors.white : const Color(0xFF8E8E8E)),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          if (isChecked)
            Positioned(
              top: 4.h,
              right: 6.w,
              child: Icon(
                Icons.check_circle,
                color: const Color(0xFFF76212),
                size: 16.sp,
              ),
            ),
        ],
      ),
    );
  }
}
