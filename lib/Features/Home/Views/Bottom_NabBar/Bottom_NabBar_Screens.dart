import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Discover/discover_screen.dart';
import '../My_List/my_list_screen.dart';
import '../Profile/profile_screen.dart';
import '../Rewards/rewards_screen.dart';
import '../Shorts/shorts_screen.dart';
import 'Controller/Bottom_NabBar_Controller.dart';

class BottomNabbarScreens extends StatelessWidget {
  const BottomNabbarScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.put(NavigationController());

    final List<Widget> pages = [
      DiscoverScreen(),
      ShortsScreen(),
      MyListScreen(),
      RewardsScreen(),
      ProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        SystemNavigator.pop();
      },
      child: SafeArea(
        child: Scaffold(
          body: Obx(() => pages[navController.currentIndex.value]),
          bottomNavigationBar: Obx(
            () => navController.showBottomNav.value
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black, // Background color
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        5,
                        (index) => _buildCustomIcon(index, navController),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomIcon(int index, NavigationController navController) {
    final bool isSelected = navController.currentIndex.value == index;

    return InkWell(
      onTap: () => navController.changeIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            _getSvgForIndex(index),
            width: 24.w,
            height: 24.w,
            colorFilter: ColorFilter.mode(
              isSelected ? AppColors.white100 : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            _getLabelForIndex(index),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isSelected ? AppColors.white100 : Colors.grey,
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
