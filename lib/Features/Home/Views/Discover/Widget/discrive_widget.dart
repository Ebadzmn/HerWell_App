import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Controller/discover_controller.dart';
import '../Models/discrive_models.dart';
import 'MovieCard.dart';
export 'MovieCard.dart';
export 'TopPicksList.dart';

class DiscoverSearchBar extends StatelessWidget {
  const DiscoverSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Color(0xFF1D1817),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      Get.find<DiscoverController>().onSearchChanged(value);
                    },
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: "Search movies...",
                      hintStyle: TextStyle(
                        color: Color(0xFFC5C5C5),
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SvgPicture.asset(AppIcons.sech_icon, width: 20.w, height: 20.w),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.standardVip);
          },
          child: SvgPicture.asset(AppIcons.vip_icon, width: 32.w, height: 32.w),
        ),
      ],
    );
  }
}

// Category Tabs Section (at the top)
class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiscoverController>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.categories.map((category) {
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            return GestureDetector(
              onTap: () => controller.changeCategory(category),
              child: Padding(
                padding: EdgeInsets.only(right: 24.w),
                child: IntrinsicWidth(
                  child: Column(
                    children: [
                      CustomText(
                        text: category,
                        fontSize: 16.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF8E8E8E),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        height: 2.h,
                        width: double.infinity,
                        color: isSelected
                            ? const Color(0xFFF76212)
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;
  const SectionHeader({super.key, required this.title, this.onMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        if (onMore != null)
          GestureDetector(
            onTap: onMore,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16.sp,
            ),
          ),
      ],
    );
  }
}

class MovieGrid extends StatelessWidget {
  final List<dynamic> items;
  final int count;
  const MovieGrid({super.key, required this.items, required this.count});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        mainAxisSpacing: 0.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.52,
      ),
      itemBuilder: (context, index) {
        return MovieCard(movie: items[index]);
      },
    );
  }
}

class SearchResultsView extends StatelessWidget {
  final DiscoverController controller;
  const SearchResultsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isSearchLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: CircularProgressIndicator(color: const Color(0xFFF76212)),
          ),
        );
      }

      if (controller.searchErrorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: CustomText(
              text: controller.searchErrorMessage.value,
              color: Colors.redAccent,
            ),
          ),
        );
      }

      if (controller.searchResults.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: CustomText(
              text: "No content found",
              color: Colors.white54,
              fontSize: 16.sp,
            ),
          ),
        );
      }

      final mappedItems = controller.searchResults.map((entity) {
        return DiscoverMovie(
          id: entity.id,
          title: entity.title,
          subtitle: entity.type,
          image: entity.posterUrl,
          badge: entity.isRecent ? 'New' : null,
          views: entity.rating.toString(),
          categories: [],
        );
      }).toList();

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mappedItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 0.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 0.52,
        ),
        itemBuilder: (context, index) {
          return MovieCard(movie: mappedItems[index]);
        },
      );
    });
  }
}
