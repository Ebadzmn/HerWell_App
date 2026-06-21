import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uremz100/Utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width = double.maxFinite,
    this.style,
    this.padding,
    this.borderColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.red100,
          foregroundColor: textColor ?? AppColors.white100,
          elevation: 0,
          padding:
              padding ??
              EdgeInsets.symmetric(vertical: 12.h), // Adjust padding if needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style:
              style ??
              GoogleFonts.inter(
                fontSize: fontSize ?? 16.sp, // Default font size with scaling
                fontWeight: fontWeight ?? FontWeight.w600,
                color: textColor ?? AppColors.white100,
              ),
        ),
      ),
    );
  }
}
