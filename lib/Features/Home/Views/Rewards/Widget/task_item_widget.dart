import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Model/rewards_model.dart';

class TaskItemWidget extends StatelessWidget {
  final String title;
  final String? titleSuffix;
  final String? subtitle;
  final String? coinsLabel;
  final String buttonText;
  final bool isHighlight;
  final String layoutType; // 'subtitle_coins' or 'top_coins'
  final List<RewardStepModel>? steps;
  final VoidCallback onTap;
  final bool isLoading;

  const TaskItemWidget({
    super.key,
    required this.title,
    this.titleSuffix,
    this.subtitle,
    this.coinsLabel,
    required this.buttonText,
    this.isHighlight = false,
    this.layoutType = 'top_coins',
    this.steps,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
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
                    if (layoutType == 'subtitle_coins') ...[
                      CustomText(
                        text: title,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xFFEDADA1),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(text: subtitle ?? ""),
                            TextSpan(
                              text: " $coinsLabel ",
                              style: TextStyle(
                                color: AppColors.yellow100,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(text: "Coins"),
                          ],
                        ),
                      ),
                    ] else if (layoutType == 'top_coins') ...[
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.rewards__rank_icon,
                            height: 20.w,
                            width: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: coinsLabel ?? "",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.yellow100,
                          ),
                          if (titleSuffix != null) ...[
                            SizedBox(width: 4.w),
                            CustomText(
                              text: titleSuffix!,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ],
                        ],
                      ),
                      CustomText(
                        text: title,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFEDADA1),
                      ),
                    ],
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (buttonText == "Claimed" || isLoading) ? null : onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonText == "Claimed"
                      ? Colors.grey.withOpacity(0.5)
                      : (isHighlight ? AppColors.yellow200 : AppColors.orange100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 16.h,
                        width: 16.h,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : CustomText(
                        text: buttonText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: buttonText == "Claimed" ? Colors.white70 : (isHighlight ? Colors.black : Colors.white),
                      ),
              ),
            ],
          ),
          if (steps != null && steps!.isNotEmpty) ...[
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps!.map((step) {
                return _RewardSmallStepWidget(
                  coins: step.coins,
                  time: step.time,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardSmallStepWidget extends StatelessWidget {
  final String coins;
  final String time;

  const _RewardSmallStepWidget({
    Key? key,
    required this.coins,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFF131416).withOpacity(0.4),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.rewards__rank_icon,
                height: 18.w,
                width: 18.w,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: coins,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        CustomText(
          text: time,
          fontSize: 10.sp,
          color: AppColors.white100,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
