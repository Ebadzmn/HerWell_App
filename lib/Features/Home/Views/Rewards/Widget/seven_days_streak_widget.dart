import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Controller/rewards_controller.dart';

class SevenDaysStreakWidget extends StatelessWidget {
  SevenDaysStreakWidget({super.key});

  final RewardsController controller = Get.find<RewardsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C4E32),
            const Color(0xFF1A1B20).withOpacity(0.5),
            const Color(0xFF1A1B20),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "7 Days Streak",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    SizedBox(height: 5.h),
                    Obx(
                      () => CustomText(
                        text: "Checked in for ${controller.currentStreak.value} consecutive days",
                        fontSize: 12.sp,
                        color: const Color(0xFFEDADA1), // Match the watch dramas text color
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => GestureDetector(
                onTap: controller.canCheckIn.value ? () {
                  controller.claimDailyCheckIn();
                } : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    gradient: controller.canCheckIn.value 
                        ? const LinearGradient(
                            colors: [Color(0xFFF76212), Color(0xFFE36D00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: controller.canCheckIn.value ? null : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: controller.canCheckIn.value ? [
                      BoxShadow(
                        color: const Color(0xFFF76212).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ] : null,
                  ),
                  child: CustomText(
                    text: controller.canCheckIn.value 
                        ? "Check-in" 
                        : controller.checkInRemainingTime.value,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
            ],
          ),
          SizedBox(height: 22.h),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                return Obx(() {
                  bool isChecked = controller.checkedInDays[index + 1] ?? false;
                  bool isToday = index == controller.currentStreak.value;
                  int coinAmount = controller.streakRewards[index];
                  bool isLastDay = index == 6;

                  return Container(
                    width: 56.w,
                    margin: EdgeInsets.only(right: index == 6 ? 0 : 12.w),
                    decoration: BoxDecoration(
                      color: isChecked 
                          ? const Color(0xFFF76212).withOpacity(0.15) 
                          : const Color(0xFF23242A),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: isChecked 
                            ? const Color(0xFFF76212).withOpacity(0.5)
                            : isToday 
                                ? const Color(0xFFF76212) 
                                : Colors.white10,
                        width: isToday || isChecked ? 1.5 : 1,
                      ),
                      boxShadow: isToday ? [
                        BoxShadow(
                          color: const Color(0xFFF76212).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ] : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Day ${index + 1}",
                              fontSize: 11.sp,
                              color: isChecked || isToday ? Colors.white : const Color(0xFF8E8E8E),
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8.h),
                            isLastDay 
                              ? Icon(Icons.card_giftcard, color: isChecked || isToday ? const Color(0xFFF76212) : const Color(0xFF8E8E8E), size: 24.sp)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.rewards__rank_icon,
                                      width: 14.w,
                                      height: 14.w,
                                      colorFilter: isChecked ? null : const ColorFilter.mode(Color(0xFF8E8E8E), BlendMode.srcIn),
                                    ),
                                    SizedBox(width: 3.w),
                                    CustomText(
                                      text: "+${coinAmount}",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isChecked || isToday ? const Color(0xFFF76212) : const Color(0xFF8E8E8E),
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
