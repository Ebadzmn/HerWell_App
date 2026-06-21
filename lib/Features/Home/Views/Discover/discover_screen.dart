import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/LoginPopup.dart';
import 'package:uremz100/Shared/Widgets/DailyBonusCoinPopup.dart';
import 'package:uremz100/Shared/Widgets/MovieDetailsPopup.dart';
import 'Controller/discover_controller.dart';
import '../../Controllers/ranking_controller.dart';
import 'Widget/discrive_widget.dart';
import 'Popular/popular.dart';
import 'New/new.dart';
import 'Vip/vip.dart';
import 'Ranking/ranking.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiscoverController());
    final rankingController = Get.put(RankingController());
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      const DiscoverSearchBar(),
                      SizedBox(height: 18.h),
                      Obx(() => controller.isSearching.value || controller.searchTerm.value.isNotEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                const CategoryTabs(),
                                SizedBox(height: 5.h),
                              ],
                            )),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xFFF76212),
                    backgroundColor: const Color(0xFF1D1817),
                    onRefresh: controller.refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Obx(() {
                            if (controller.isSearching.value || controller.searchTerm.value.isNotEmpty) {
                              return SearchResultsView(controller: controller);
                            }
                            switch (controller.selectedCategory.value) {
                              case 'Popular':
                                return PopularView(controller: controller);
                              case 'New':
                                return NewView(controller: controller);
                              case 'VIP':
                                return VipView(controller: controller);
                              case 'Ranking':
                                return RankingView(controller: rankingController);
                              default:
                                return PopularView(controller: controller);
                            }
                          }),
                          SizedBox(height: 40.h), // Space for bottom navigation
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => controller.showBonusPopup.value
                ? DailyBonusPopup(onClose: controller.closePopup)
                : const SizedBox.shrink(),
          ),
          Obx(
            () => controller.showMoviePopup.value && controller.selectedMovie.value != null
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: MovieDetailsPopup(
                      movie: controller.selectedMovie.value!,
                      onClose: controller.closeMoviePopup,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          // Login Popup
          Obx(
            () => controller.showLoginPopup.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: LoginPopup(
                      onSignIn: () {
                        controller.showLoginPopup.value = false;
                        Get.toNamed(Routes.signinScreen);
                      },
                      onClose: controller.closeLoginPopup,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
