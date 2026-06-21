import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_AppBar.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'Controller/my_list_controller.dart';
import 'package:uremz100/Data/Models/recently_watched_model.dart';
import 'package:uremz100/Data/Models/my_collection_model.dart';
import 'package:uremz100/Features/Home/Views/Bottom_NabBar/Controller/Bottom_NabBar_Controller.dart';
import 'package:uremz100/Features/Home/Views/Discover/Controller/discover_controller.dart';

class MyListScreen extends GetView<MyListController> {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyListController());
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Collection",
        onBackPressed: () {
          try {
            final NavigationController navController =
                Get.find<NavigationController>();
            if (navController.currentIndex.value == 2) {
              navController.changeIndex(0);
            } else {
              Get.back();
            }
          } catch (e) {
            Get.back();
          }
        },
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.standardVip),
              child: SvgPicture.asset(
                AppIcons.vip_icon,
                height: 30.w,
                width: 30.w,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await controller.refreshRecentlyWatched();
              await controller.refreshMyCollection();
            },
            child: SingleChildScrollView(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildSectionHeader("Recently Watched"),
                  SizedBox(height: 15.h),
                  Obx(() {
                    if (controller.isRecentlyWatchedLoading.value &&
                        controller.recentlyWatched.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.recentlyWatchedError.isNotEmpty &&
                        controller.recentlyWatched.isEmpty) {
                      return CustomText(
                        text: controller.recentlyWatchedError.value,
                        color: Colors.red,
                      );
                    }
                    if (controller.recentlyWatched.isEmpty) {
                      return _buildEmptyState(
                        "No recently watched items.",
                        Icons.history,
                      );
                    }
                    return _buildRecentlyWatchedGrid(
                      controller.recentlyWatched,
                      controller.isSelectionMode.value,
                    );
                  }),
                  SizedBox(height: 18.h),
                  _buildSectionHeader("My Collection"),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (controller.isMyCollectionLoading.value &&
                        controller.myCollection.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.myCollectionError.isNotEmpty &&
                        controller.myCollection.isEmpty) {
                      return CustomText(
                        text: controller.myCollectionError.value,
                        color: Colors.red,
                      );
                    }
                    if (controller.myCollection.isEmpty) {
                      return _buildEmptyState(
                        "Your collection is empty.",
                        Icons.video_library_outlined,
                      );
                    }
                    return Column(
                      children: [
                        _buildMyCollectionGrid(
                          controller.myCollection,
                          controller.isSelectionMode.value,
                        ),
                        if (controller.isMyCollectionPaginating.value)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: const CircularProgressIndicator(),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 180.h), // Space for bottom buttons
                ],
              ),
            ),
          ),
          Obx(
            () => controller.isSelectionMode.value
                ? _buildBottomActionBar()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return CustomText(
      text: title,
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.sp, color: Colors.grey.shade600),
          SizedBox(height: 12.h),
          CustomText(
            text: message,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyWatchedGrid(
    List<RecentlyWatchedData> items,
    bool isSelectionMode,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.55,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildRecentlyWatchedCard(item, isSelectionMode);
      },
    );
  }

  Widget _buildMyCollectionGrid(
    List<MyCollectionData> items,
    bool isSelectionMode,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.55,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildMyCollectionCard(item, isSelectionMode);
      },
    );
  }

  Widget _buildRecentlyWatchedCard(
    RecentlyWatchedData item,
    bool isSelectionMode,
  ) {
    return GestureDetector(
      onLongPress: controller.toggleSelectionMode,
      onTap: () {
        if (controller.isSelectionMode.value) {
          controller.toggleItemSelected(item.contentId.id);
        } else {
          if (Get.isRegistered<DiscoverController>()) {
            Get.find<DiscoverController>().playContentDirectly(item.contentId.id);
          } else {
            final discoverController = Get.put(DiscoverController());
            discoverController.playContentDirectly(item.contentId.id);
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: item.contentId.posterUrl.isNotEmpty
                    ? Image.network(
                        item.contentId.posterUrl,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),
              // Ribbon Badge
              if (item.contentId.type.isNotEmpty)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getBadgeColor(item.contentId.type),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.r),
                        bottomLeft: Radius.circular(8.r),
                      ),
                    ),
                    child: CustomText(
                      text: item.contentId.type.toUpperCase(),
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              // Play Count / Progress
              Positioned(
                bottom: 8.h,
                right: 4.w,
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 16.sp),
                    SizedBox(width: 2.w),
                    CustomText(
                      text: "${item.completionPercentage.toInt()}%",
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              // Selection Overlay
              if (isSelectionMode)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Obx(() {
                    final isSelected = controller.selectedItems.contains(
                      item.contentId.id,
                    );
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFD700) // Golden/Yellow circle
                            : Colors.black38,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.w),
                      ),
                      child: Icon(
                        Icons.check,
                        color: isSelected ? Colors.white : Colors.transparent,
                        size: 12.sp,
                      ),
                    );
                  }),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: item.contentId.title,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE3E3E3),
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: "Watched", // Fallback subtitle
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFFE3E3E3),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMyCollectionCard(MyCollectionData item, bool isSelectionMode) {
    return GestureDetector(
      onLongPress: controller.toggleSelectionMode,
      onTap: () {
        if (controller.isSelectionMode.value) {
          controller.toggleItemSelected(item.itemId.id);
        } else {
          if (Get.isRegistered<DiscoverController>()) {
            Get.find<DiscoverController>().playContentDirectly(item.itemId.id);
          } else {
            final discoverController = Get.put(DiscoverController());
            discoverController.playContentDirectly(item.itemId.id);
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: item.itemId.posterUrl.isNotEmpty
                    ? Image.network(
                        item.itemId.posterUrl,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),
              // Ribbon Badge
              if (item.itemId.type.isNotEmpty)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getBadgeColor(item.itemId.type),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.r),
                        bottomLeft: Radius.circular(8.r),
                      ),
                    ),
                    child: CustomText(
                      text: item.itemId.type.toUpperCase(),
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              // Selection Overlay
              if (isSelectionMode)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Obx(() {
                    final isSelected = controller.selectedItems.contains(
                      item.itemId.id,
                    );
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFD700) // Golden/Yellow circle
                            : Colors.black38,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.w),
                      ),
                      child: Icon(
                        Icons.check,
                        color: isSelected ? Colors.white : Colors.transparent,
                        size: 12.sp,
                      ),
                    );
                  }),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: item.itemId.title,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE3E3E3),
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: "Collection", // Fallback subtitle
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFFE3E3E3),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 150.h,
      width: double.infinity,
      color: Colors.grey.shade800,
      child: Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey.shade500),
      ),
    );
  }

  Color _getBadgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'exclusive':
        return Color(0xFFF76212);
      case 'new':
        return Color(0xFFF76212);
      case 'vip':
        return Color(0xFFF76212);
      default:
        return Color(0xFFF76212);
    }
  }

  Widget _buildBottomActionBar() {
    return Positioned(
      bottom: 20.h,
      left: 16.w,
      right: 16.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(
            0xFF1E1E1E,
          ).withOpacity(0.95), // Elegant dark background
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.orange100, width: 1.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextButton(
                  onPressed: controller.toggleSelectAll,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Obx(
                    () => CustomText(
                      text: controller.isAllSelected
                          ? "Deselect All"
                          : "Select All",
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Obx(
                () => SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: controller.selectedItems.isNotEmpty
                        ? controller.removeSelected
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedItems.isNotEmpty
                          ? AppColors.orange100
                          : Colors.grey.shade800,
                      disabledBackgroundColor: Colors.grey.shade800,
                      elevation: controller.selectedItems.isNotEmpty ? 4 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: CustomText(
                      text: controller.selectedItems.isNotEmpty
                          ? "Remove (${controller.selectedItems.length})"
                          : "Remove",
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: controller.selectedItems.isNotEmpty
                          ? Colors.white
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
