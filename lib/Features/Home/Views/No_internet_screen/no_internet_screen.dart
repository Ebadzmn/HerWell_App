import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Features/Auth/Controllers/interner_controller.dart';
import 'package:uremz100/Utils/app_colors.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final internet = Get.find<InternetController>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80.sp),
              SizedBox(height: 16.h),
              Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                'Please check your internet and try again',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100.w, 40.h),
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
                onPressed: () {
                  // if (internet.hasInternet.value) {
                  //   internet.setOnline();
                  //   Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
                  // }
                },
                child: Text('Retry', style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
