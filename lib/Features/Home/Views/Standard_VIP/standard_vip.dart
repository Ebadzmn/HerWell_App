import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Bottom_NabBar/Controller/Bottom_NabBar_Controller.dart';
import 'Basic_VIP/basic_vip.dart';
import 'Controller/standart_vip_controller.dart';
import 'Widget/subscribe_widgets.dart';

class StandardVip extends StatelessWidget {
  const StandardVip({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.find<NavigationController>();
    final StandartVipController controller = Get.put(StandartVipController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            CustomText(
              text: "Become Standard VIP to Access All",
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
            CustomText(
              text: "Exclusive Features",
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
            SizedBox(height: 30.h),
           // // Custom TabBar
           //  Obx(
           //    () => Container(
           //      height: 45.h,
           //      decoration: BoxDecoration(
           //        color: const Color(0xFF1F1F1F),
           //        borderRadius: BorderRadius.circular(8.r),
           //      ),
           //      child: Row(
           //        children: [
           //          _buildTabItem(
           //            "Standard VIP",
           //            isSelected: controller.selectedTabIndex.value == 0,
           //            onTap: () => controller.changeTab(0),
           //            isLeft: true,
           //          ),
           //          _buildTabItem(
           //            "Basic VIP",
           //            isSelected: controller.selectedTabIndex.value == 1,
           //            onTap: () => controller.changeTab(1),
           //            isLeft: false,
           //          ),
           //        ],
           //      ),
           //    ),
           //  ),
           //  SizedBox(height: 13.h),
           // Content based on tab
            Obx(() {
              if (controller.selectedTabIndex.value == 0) {
                return _buildStandardContent(controller);
              } else {
                return const BasicVip();
              }
            }),
            SubscriptionRules(rules: controller.subscriptionRules),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              5,
              (index) => _buildCustomIcon(index, navController),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    String title, {
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF764820) : Color(0xFF3F3E3E),
            borderRadius: isLeft
                ? BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomLeft: Radius.circular(8.r),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
          ),
          child: CustomText(
            text: title,
            fontSize: 18.sp,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
            color: isSelected ? Colors.white : Color(0xFFB0B0B0),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardContent(StandartVipController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...controller.standardPlans.map((plan) => SubscribeCard(plan: plan)),
        MovieGrid(movies: controller.bestMovies, title: "Best Movies"),
        MovieGrid(movies: controller.comingSoonMovies, title: "Coming Soon"),
      ],
    );
  }

  Widget _buildCustomIcon(int index, NavigationController navController) {
    final bool isSelected = navController.currentIndex.value == index;

    return GestureDetector(
      onTap: () {
        navController.changeIndex(index);
        Get.back();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            _getSvgForIndex(index),
            width: 24.w,
            height: 24.w,
            colorFilter: ColorFilter.mode(
              isSelected ? Colors.white : AppColors.gray400,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            _getLabelForIndex(index),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  String _getSvgForIndex(int index) {
    switch (index) {
      case 0:
        return AppIcons.discover_icon;
      case 1:
        return AppIcons.shorts_icon;
      case 2:
        return AppIcons.my_list_icon;
      case 3:
        return AppIcons.rewards_icon;
      case 4:
        return AppIcons.profile_icon;
      default:
        return '';
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Discover';
      case 1:
        return 'Shorts';
      case 2:
        return 'My List';
      case 3:
        return 'Rewards';
      case 4:
        return 'Profile';
      default:
        return '';
    }
  }
}
