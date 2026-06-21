import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Shared/Widgets/Custom_AppBar.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:flutter_html/flutter_html.dart';
import '../Legal/Controller/legal_controller.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final controller = Get.put(LegalController());

  @override
  void initState() {
    super.initState();
    controller.fetchLegalPage('privacy-policy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Privacy Policy", showBackButton: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: controller.errorMessage.value,
                  fontSize: 14.sp,
                  color: Colors.red,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.fetchLegalPage('privacy-policy'),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: controller.title.value.isNotEmpty ? controller.title.value : "🔐 Privacy Policy",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 20.h),
              Html(
                data: controller.content.value,
                style: {
                  "body": Style(
                    color: const Color(0xFFE4E4E4),
                    fontSize: FontSize(14.sp),
                    fontWeight: FontWeight.w400,
                  ),
                  "h1": Style(color: Colors.white, fontSize: FontSize(18.sp), fontWeight: FontWeight.w600),
                  "h2": Style(color: Colors.white, fontSize: FontSize(16.sp), fontWeight: FontWeight.w600),
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
