import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';

class MoreScreenWidgets {
  static Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: CustomText(
        text: title,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  static Widget buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF292929),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: "$tag ›",
        fontSize: 12.sp,
        color: const Color(0xFFB3B3B3),
      ),
    );
  }

  static Widget buildRelatedItem(
    String title,
    String category,
    String views,
    String imageUrl,
    bool isNew,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                imageUrl,
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            if (isNew)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8124C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  child: CustomText(
                    text: "New",
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
              bottom: 4.h,
              right: 6.w,
              child: Row(
                children: [
                  const Icon(Icons.play_arrow, color: Colors.white, size: 12),
                  CustomText(text: views, fontSize: 10.sp, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        CustomText(
          text: title,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          maxLines: 2,
        ),
        SizedBox(height: 2.h),
        CustomText(
          text: category,
          fontSize: 10.sp,
          color: const Color(0xFF8E8E8E),
        ),
      ],
    );
  }
}
