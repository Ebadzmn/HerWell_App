import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uremz100/Utils/app_colors.dart';

class CustomTextgray extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomTextgray({
    super.key,
    required this.text,
    this.textAlign,
    this.textStyle,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle = GoogleFonts.inter(
      color: color ?? AppColors.white100,
      fontSize: fontSize ?? 14.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines,
      style:
          textStyle ??
          baseStyle.copyWith(
            fontFamily:
                fontFamily ?? 'Inter', // Default to 'Inter', or use custom font
          ),
    );
  }
}
