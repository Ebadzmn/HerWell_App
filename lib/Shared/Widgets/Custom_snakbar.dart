import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCustomSnackBar(
  String? message, {
  bool isError = true,
  bool getXSnackBar = true,
  Duration? duration,
}) {
  if (message != null && message.isNotEmpty) {
    if (getXSnackBar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.showSnackbar(
          GetSnackBar(
            messageText: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp, // responsive font size
                fontWeight: FontWeight.w500,
                color: isError ? Colors.red.shade900 : Colors.green.shade900,
              ),
            ),
            duration: duration ?? Duration(seconds: 3),
            snackStyle: SnackStyle.FLOATING,
            margin: EdgeInsets.all(10.w), // responsive margin
            borderRadius: 8.r, // responsive radius
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            backgroundColor: isError
                ? Colors.red.shade100
                : Colors.green.shade100,
            snackPosition: SnackPosition.BOTTOM,
          ),
        );
      });
    } else {
      final context = Get.context;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.horizontal,
            margin: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ), // responsive margin
            duration: duration ?? Duration(seconds: 3),
            backgroundColor: isError
                ? Colors.red.shade100
                : Colors.green.shade100,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r), // responsive radius
            ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp, // responsive font size
                fontWeight: FontWeight.w500,
                color: isError ? Colors.red.shade900 : Colors.green.shade900,
              ),
            ),
          ),
        );
      }
    }
  }
}
