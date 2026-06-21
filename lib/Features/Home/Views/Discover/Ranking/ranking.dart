import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'package:uremz100/Features/Home/Controllers/ranking_controller.dart';
import 'package:uremz100/Features/Home/Views/Discover/Controller/discover_controller.dart';

class RankingView extends StatelessWidget {
  final RankingController controller;
  const RankingView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSmallTab("Popular"),
                SizedBox(width: 10.w),
                _buildSmallTab("Daily Top"),
                SizedBox(width: 10.w),
                _buildSmallTab("Weekly Top"),
                SizedBox(width: 10.w),
                _buildSmallTab("Monthly Top"),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: const CircularProgressIndicator(color: Color(0xFFF76212)),
              ),
            );
          }
          if (controller.hasError.value && controller.rankingItems.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Column(
                  children: [
                    Text(controller.errorMessage.value, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF76212)),
                      onPressed: controller.retry,
                      child: const Text('Retry', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }
          if (controller.rankingItems.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Text('No rankings available', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.rankingItems.length,
            itemBuilder: (context, index) {
              return _buildRankingItem(index);
            },
          );
        }),
      ],
    );
  }

  Widget _buildSmallTab(String label) {
    final isSelected = controller.selectedRankingTab.value == label;
    return GestureDetector(
      onTap: () => controller.changeRankingTab(label),
      child: Container(
        constraints: BoxConstraints(minWidth: 76.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0xFF262626),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.black : const Color(0xFFD9D9D9),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankingItem(int index) {
    final movie = controller.rankingItems[index];
    return GestureDetector(
      onTap: () => Get.find<DiscoverController>().playContentDirectly(movie.id),
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: movie.posterUrl.isEmpty
                      ? Container(
                          width: 80.w,
                          height: 100.h,
                          color: const Color(0xFF262626),
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        )
                      : Image.network(
                          movie.posterUrl,
                          width: 80.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80.w,
                            height: 100.h,
                            color: const Color(0xFF262626),
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF76212),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.r),
                        bottomLeft: Radius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "${index + 1}",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFF76212),
                            size: 14.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            movie.rating?.toString() ?? '0',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFF76212),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(right: 60.w),
                    child: Text(
                      movie.type,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFD9D9D9),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
