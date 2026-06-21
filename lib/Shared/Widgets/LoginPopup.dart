import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'Custom_Text.dart';

class LoginPopup extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onClose;

  const LoginPopup({super.key, required this.onSignIn, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Megaphone Icon
                  SvgPicture.asset(
                    AppIcons.alarm_icon,
                    height: 60.w,
                    width: 60.w,
                  ),
                  SizedBox(height: 20.h),

                  // Text Content
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: "To "),
                        TextSpan(
                          text: "Protect your property,",
                          style: TextStyle(color: AppColors.orange100),
                        ),
                        const TextSpan(
                          text:
                              "\nPlease log in to your account\nto avoid loss of information!",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                      child: CustomText(
                        text: "Sign In",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Close Button
            Positioned(
              top: 16.h,
              right: 16.w,
              child: GestureDetector(
                onTap: onClose,
                child: Icon(Icons.close, size: 20.w, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
