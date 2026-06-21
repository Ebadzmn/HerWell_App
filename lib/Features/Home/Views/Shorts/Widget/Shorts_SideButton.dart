import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uremz100/Utils/app_colors.dart';




class ShortsSideButton extends StatelessWidget {
  final String? iconPath;
  final Widget? icon;
  final String? label;
  final VoidCallback onTap;
  final Color? color;

  const ShortsSideButton({
    super.key,
    this.iconPath,
    this.icon,
    this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          children: [
            icon ??
                (iconPath != null
                    ? SvgPicture.asset(
                  iconPath!,
                  width: 28.w,
                  height: 28.w,
                  colorFilter: color != null
                      ? ColorFilter.mode(color!, BlendMode.srcIn)
                      : null,
                )
                    : const SizedBox()),
            if (label != null) ...[
              SizedBox(height: 14.h),
              Text(
                label!,
                style: GoogleFonts.inter(
                  color: AppColors.white100,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
