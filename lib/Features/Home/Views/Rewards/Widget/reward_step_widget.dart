import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';

class RewardStepWidget extends StatelessWidget {
  final String coins;
  final String time;
  final bool isCompleted;
  final bool isActive;

  const RewardStepWidget({
    super.key,
    required this.coins,
    required this.time,
    this.isCompleted = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isFuture = !isActive && !isCompleted;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFFF76212).withOpacity(0.15) : const Color(0xFF131416).withOpacity(0.4),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isActive ? const Color(0xFFF76212) : (isCompleted ? const Color(0xFFF76212).withOpacity(0.5) : Colors.white.withOpacity(0.08)), 
              width: isActive || isCompleted ? 1.5 : 1
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.rewards__rank_icon,
                height: 24.w,
                width: 24.w,
                colorFilter: isFuture 
                    ? const ColorFilter.mode(Color(0xFF8E8E8E), BlendMode.srcIn) 
                    : null,
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: coins,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isFuture ? const Color(0xFF8E8E8E) : Colors.white,
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        CustomText(
          text: time,
          fontSize: 12.sp,
          color: isFuture ? const Color(0xFF8E8E8E) : AppColors.white100,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
