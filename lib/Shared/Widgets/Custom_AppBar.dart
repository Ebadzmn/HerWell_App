import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? backButtonColor;
  final double? elevation;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleStyle,
    this.centerTitle = true,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor = Colors.transparent,
    this.backButtonColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                CupertinoIcons.back,
                color: backButtonColor ?? AppColors.white100,
                size: 24.sp,
              ),
              onPressed: onBackPressed ?? () => Get.back(),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style:
                  titleStyle ??
                  TextStyle(
                    color: AppColors.white100,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.h);
}
