import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import '../Models/discrive_models.dart';
import '../Controller/discover_controller.dart';
import '../Widget/discrive_widget.dart';

class NewView extends StatelessWidget {
  final DiscoverController controller;
  const NewView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isNewLoading.value) {
        return SizedBox(
          height: 400.h,
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFF76212)),
          ),
        );
      }

      if (controller.hasNewError.value) {
        return SizedBox(
          height: 400.h,
          child: Center(
            child: CustomText(
              text: controller.newErrorMessage.value,
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.newSections.length,
        itemBuilder: (context, index) {
          final section = controller.newSections[index];
          final items = section.items;

          // Map ContentItem to DiscoverMovie
          final mappedItems = items.map((item) => DiscoverMovie(
            id: item.id.toString(),
            title: item.title,
            subtitle: item.contentType,
            image: item.posterUrl,
            badge: item.isRecent ? 'New' : null,
            views: item.rating.toString(),
            categories: ['New'],
          )).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: section.title),
              SizedBox(height: 12.h),
              if (items.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: CustomText(
                      text: "No content available yet.",
                      color: Colors.white54,
                      fontSize: 14.sp,
                    ),
                  ),
                )
              else if (section.type == 'COMING_SOON')
                MovieGrid(items: mappedItems, count: 3)
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mappedItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.55,
                  ),
                  itemBuilder: (context, i) {
                    final movie = mappedItems[i];
                    bool isSecondInRow = i % 2 != 0;
                    bool isLastTwoRows = i >= 2;
                    return Padding(
                      padding: EdgeInsets.only(
                        top: (isSecondInRow && isLastTwoRows) ? 12.h : 0,
                      ),
                      child: _buildNewReleaseCard(movie),
                    );
                  },
                ),
              SizedBox(height: 24.h),
            ],
          );
        },
      );
    });
  }

  Widget _buildNewReleaseCard(DiscoverMovie movie) {
    return GestureDetector(
      onTap: () => controller.playContentDirectly(movie.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: movie.image.startsWith('http')
                      ? Image.network(
                          movie.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[800],
                            child: const Icon(Icons.broken_image, color: Colors.white54),
                          ),
                        )
                      : (movie.image.isEmpty
                          ? Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[800],
                              child: const Icon(Icons.broken_image, color: Colors.white54),
                            )
                          : Image.asset(
                              movie.image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )),
                ),
                // "New" Badge
                if (movie.badge != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF76212),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.r),
                          bottomLeft: Radius.circular(12.r),
                        ),
                      ),
                      child: CustomText(
                        text: movie.badge!,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Play Icon and Views
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 14.sp),
                      SizedBox(width: 2.w),
                      CustomText(
                        text: movie.views,
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: movie.title,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: movie.subtitle,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E8E),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
