import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uremz100/Utils/app_colors.dart';

class CustomButtonIcon extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Widget? iconWidget;

  const CustomButtonIcon({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget? displayIcon;
    if (iconWidget != null) {
      displayIcon = iconWidget;
    } else if (icon != null) {
      displayIcon = Icon(icon, size: 24.sp);
    }

    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(color: AppColors.white100),
          ),
        ),
        child: displayIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  displayIcon,
                  SizedBox(width: 8.w),
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.white100,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
