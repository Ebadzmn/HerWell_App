import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import '../Models/discrive_models.dart';
import '../Controller/discover_controller.dart';
import '../Widget/discrive_widget.dart';

class VipView extends StatelessWidget {
  final DiscoverController controller;
  const VipView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildToggleButton("Daily"),
              SizedBox(width: 10.w),
              _buildToggleButton("Weekly"),
            ],
          ),
          SizedBox(height: 16.h),
          if (controller.isVipLoading.value)
            SizedBox(
              height: 400.h,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFF76212)),
              ),
            )
          else if (controller.hasVipError.value)
            SizedBox(
              height: 400.h,
              child: Center(
                child: CustomText(
                  text: controller.vipErrorMessage.value,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.vipSections.length,
              itemBuilder: (context, index) {
                final section = controller.vipSections[index];
                final items = section.items;

                final mappedItems = items.map((item) => DiscoverMovie(
                  id: item.id.toString(),
                  title: item.title,
                  subtitle: item.contentType,
                  image: item.posterUrl,
                  badge: item.isRecent ? 'New' : null,
                  views: item.rating.toString(),
                  categories: ['VIP'],
                )).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: section.title, onMore: () {}),
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
                    else
                      _buildVipGrid(mappedItems, forceVipBadge: section.type == 'VIP'),
                    SizedBox(height: 24.h),
                  ],
                );
              },
            ),
        ],
      );
    });
  }

  // --- VIP Custom Grid ---
  Widget _buildVipGrid(
    List<DiscoverMovie> items, {
    bool forceVipBadge = false,
    bool forceNewBadge = false,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.55, // Adjusted for tall VIP cards
      ),
      itemBuilder: (context, index) {
        return _buildVipMovieCard(
          items[index],
          forceVipBadge: forceVipBadge,
          forceNewBadge: forceNewBadge,
        );
      },
    );
  }

  // --- VIP Custom Movie Card ---
  Widget _buildVipMovieCard(
    DiscoverMovie movie, {
    bool forceVipBadge = false,
    bool forceNewBadge = false,
  }) {
    // Determine which badge to show
    String? displayBadge;
    if (forceVipBadge) {
      displayBadge = "VIP";
    } else if (forceNewBadge || movie.badge != null) {
      displayBadge = forceNewBadge ? "New" : movie.badge;
    }

    return GestureDetector(
      onTap: () => controller.playContentDirectly(movie.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                // Image
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
                // Badge (VIP or New)
                if (displayBadge != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
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
                        text: displayBadge,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Play Icon and Views (Bottom Right)
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
          // Title
          CustomText(
            text: movie.title,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
          ),
          // Subtitle (Revenge, Exclusive, etc.)
          CustomText(
            text: movie.subtitle,
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E8E),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label) {
    final isSelected = controller.vipPeriod.value == label;
    return GestureDetector(
      onTap: () => controller.changeVipPeriod(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.black : const Color(0xFF8E8E8E),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
