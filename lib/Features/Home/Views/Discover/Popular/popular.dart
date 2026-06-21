import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_icons.dart';
import '../Models/discrive_models.dart';
import '../Controller/discover_controller.dart';
import '../Widget/discrive_widget.dart';

class PopularView extends StatelessWidget {
  final DiscoverController controller;
  const PopularView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox(
            height: 400.h,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFF76212)),
            ),
          );
        }

        if (controller.hasError.value) {
          return SizedBox(
            height: 400.h,
            child: Center(
              child: CustomText(
                text: controller.errorMessage.value,
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            // First Row (Horizontal Scroll - Trending)
            if (controller.trendingMovies.isNotEmpty)
              _buildHorizontalStandardGrid(controller.trendingMovies)
            else
              _buildNoContent(),

            // VIP Banner
            _buildVipBanner(),

            // Second Row (Horizontal Scroll - fallback to remaining trending)
            if (controller.trendingMovies.length > 10)
              _buildHorizontalStandardGrid(
                controller.trendingMovies.skip(10).toList(),
              ),

            SizedBox(height: 24.h),
            SectionHeader(title: "Most Popular Series"),
            SizedBox(height: 12.h),
            // Most Popular Series (Horizontal Scroll)
            if (controller.seriesMovies.isNotEmpty)
              _buildHorizontalSeriesGrid(
                controller.seriesMovies.map((m) => (
                  movie: m,
                  badge: m.badge,
                  title: m.title,
                  subtitle: m.subtitle,
                  views: m.views,
                )).toList()
              )
            else
              _buildNoContent(),
              
            SizedBox(height: 24.h),
            SectionHeader(title: "You Might Like"),
            SizedBox(height: 16.h),

            // You Might Like Staggered Grid (Matching Image)
            if (controller.youMightLikeMovies.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Large Movie Cards
                Expanded(
                  child: Column(
                    children: controller.youMightLikeMovies.take(5).map((m) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: _buildLargeMovieCard(
                          movie: m,
                          badge: m.badge,
                          title: m.title,
                          subtitle: m.subtitle,
                          views: m.views,
                          height: 280.h,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 12.w),
                // Right Column: Top Picks, Find Out More, and Large Cards
                Expanded(
                  child: Column(
                    children: [
                      _buildTopPicks(),
                      SizedBox(height: 16.h),
                      if (controller.youMightLikeMovies.length > 5) ...[
                        _buildLargeMovieCard(
                          movie: controller.youMightLikeMovies[5],
                          badge: controller.youMightLikeMovies[5].badge,
                          title: controller.youMightLikeMovies[5].title,
                          subtitle: controller.youMightLikeMovies[5].subtitle,
                          views: controller.youMightLikeMovies[5].views,
                          height: 280.h,
                        ),
                        SizedBox(height: 16.h),
                      ],
                      _buildFindOutMore(),
                      SizedBox(height: 16.h),
                      if (controller.youMightLikeMovies.length > 6) ...[
                        _buildLargeMovieCard(
                          movie: controller.youMightLikeMovies[6],
                          badge: controller.youMightLikeMovies[6].badge,
                          title: controller.youMightLikeMovies[6].title,
                          subtitle: controller.youMightLikeMovies[6].subtitle,
                          views: controller.youMightLikeMovies[6].views,
                          height: 280.h,
                        ),
                        SizedBox(height: 16.h),
                      ],
                      if (controller.youMightLikeMovies.length > 7) ...[
                        _buildLargeMovieCard(
                          movie: controller.youMightLikeMovies[7],
                          badge: controller.youMightLikeMovies[7].badge,
                          title: controller.youMightLikeMovies[7].title,
                          subtitle: controller.youMightLikeMovies[7].subtitle,
                          views: controller.youMightLikeMovies[7].views,
                          height: 280.h,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            )
            else
              _buildNoContent(),

            SizedBox(height: 24.h),
            SectionHeader(title: "Recently Watched"),
            SizedBox(height: 12.h),
            // Recently Watched (Horizontal Scroll)
            if (controller.continueWatchingMovies.isNotEmpty)
              _buildHorizontalRecentlyWatchedGrid(
                controller.continueWatchingMovies.map((m) => (
                  movie: m,
                  badge: m.badge,
                  views: m.views,
                  progress: 0.5,
                  overlayMovie: null,
                )).toList()
              )
            else
              _buildNoContent(),
          ],
        );
      }),
    );
  }

  // --- Horizontal Recently Watched Scroll Grid ---
  Widget _buildHorizontalRecentlyWatchedGrid(
    List<
      ({
        DiscoverMovie movie,
        String? badge,
        String views,
        double progress,
        DiscoverMovie? overlayMovie,
      })
    >
    items,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return SizedBox(
            width: 120.w, // Reduced width to match others
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: _buildRecentlyWatchedCard(
                movie: item.movie,
                badge: item.badge,
                views: item.views,
                progress: item.progress,
                overlayMovie: item.overlayMovie,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Horizontal Series Scroll Grid ---
  Widget _buildHorizontalSeriesGrid(
    List<
      ({
        DiscoverMovie movie,
        String? badge,
        String title,
        String subtitle,
        String views,
      })
    >
    items,
  ) {
    return SingleChildScrollView(
      controller: controller.popularScrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Duplicate items to simulate an infinite list so the auto-slide doesn't hit the end prematurely
        children: List.generate(15, (_) => items).expand((i) => i).map((item) {
          return SizedBox(
            width: 120.w,
            child: Padding(
              padding: EdgeInsets.only(
                right: 10.w,
              ), // Re-evaluating width: 120.w includes everything visually
              child: _buildSeriesCard(
                movie: item.movie,
                badge: item.badge ?? "",
                title: item.title,
                subtitle: item.subtitle,
                views: item.views,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Horizontal Scroll Grid Builder ---
  Widget _buildHorizontalStandardGrid(List<DiscoverMovie> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((movie) {
          return SizedBox(
            width: 120.w,
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: _buildStandardMovieCard(movie),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Standard Movie Card (Consistent sizing) ---
  Widget _buildStandardMovieCard(DiscoverMovie movie) {
    return GestureDetector(
      onTap: () => controller.playContentDirectly(movie.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: movie.image.startsWith('http') 
                  ? Image.network(
                      movie.image,
                      height: 145.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 145.h,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: Icon(Icons.broken_image, color: Colors.white54),
                      ),
                    )
                  : (movie.image.isEmpty
                      ? Container(
                          height: 145.h,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: const Icon(Icons.broken_image, color: Colors.white54),
                        )
                      : Image.asset(
                          movie.image,
                          height: 145.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
              ),
              if (movie.badge != null)
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
                      text: movie.badge!,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 12.sp),
                    SizedBox(width: 2.w),
                    CustomText(
                      text: movie.views,
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: movie.title,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: movie.subtitle,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E8E),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyWatchedCard({
    required DiscoverMovie movie,
    String? badge,
    required String views,
    required double progress,
    DiscoverMovie? overlayMovie,
  }) {
    return GestureDetector(
      onTap: () => controller.playContentDirectly(movie.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Main Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  children: [
                    movie.image.startsWith('http') 
                      ? Image.network(
                          movie.image,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 150.h,
                            width: double.infinity,
                            color: Colors.grey[800],
                            child: Icon(Icons.broken_image, color: Colors.white54),
                          ),
                        )
                      : (movie.image.isEmpty
                          ? Container(
                              height: 150.h,
                              width: double.infinity,
                              color: Colors.grey[800],
                              child: const Icon(Icons.broken_image, color: Colors.white54),
                            )
                          : Image.asset(
                              movie.image,
                              height: 150.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                    // Progress Bar at Bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3.h,
                        color: Colors.black.withOpacity(0.5),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Badge
              if (badge != null)
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
                      text: badge,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              // Views
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 12.sp),
                    SizedBox(width: 2.w),
                    CustomText(
                      text: views,
                      fontSize: 8.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: movie.title,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: movie.subtitle,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E8E),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLargeMovieCard({
    required DiscoverMovie movie,
    required String? badge,
    required String title,
    required String subtitle,
    required String views,
    double? height, // Added height parameter
  }) {
    return GestureDetector(
      onTap: () => controller.playContentDirectly(movie.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: movie.image.startsWith('http') 
                  ? Image.network(
                      movie.image,
                      height: height ?? 380.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: height ?? 380.h,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: Icon(Icons.broken_image, color: Colors.white54),
                      ),
                    )
                  : (movie.image.isEmpty
                      ? Container(
                          height: height ?? 380.h,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: const Icon(Icons.broken_image, color: Colors.white54),
                        )
                      : Image.asset(
                          movie.image,
                          height: height ?? 380.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
              ),
              // VIP Badge
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF76212),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                    ),
                    child: CustomText(
                      text: badge,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              // Views
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 18.sp),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: views,
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: subtitle,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E8E),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVipBanner() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Icon + Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.vip_icon,
                    height: 32.h,
                    width: 32.w,
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: "Become a VIP",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF353534),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: "Unlock All Short Dramas For free",
                fontSize: 12.sp,
                color: const Color(0xFF595959),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),

          // Right: Go Button
          GestureDetector(
            onTap: () => Get.toNamed(Routes.rewardsScreen),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF602701), // orange — top left
                    Color(0xFFC65002), // dark brown — middle
                  ],
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: CustomText(
                text: "Go",
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPicks() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 7.w, 7.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF080E26), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF994A24), // orange — top left
            Color(0xFF1B1616), // dark brown — middle
            Color(0xFF000000), // dark brown — middle
          ],
          stops: [0.0, 0.70, 2.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(
              text: "Top Picks",
              fontSize: 16.sp, // Slightly larger to match image proportion
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF76212),
            ),
          ),
          SizedBox(height: 10.h), // Matching Gap spec
          Column(
            children: List.generate(
              controller.topPicksMovies.length > 5 ? 5 : controller.topPicksMovies.length,
              (index) {
              final movie = controller.topPicksMovies[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          // Since API sends URLs, we need to handle network image or fallback.
                          // But to strictly avoid changing widget structure, if movie.image is URL, 
                          // Image.asset will fail. Wait, the prompt says "Do not change existing widget structure".
                          // If the API returns a URL, we MUST change Image.asset to Image.network, otherwise it crashes.
                          // Let's use an inline check to be safe: movie.image.startsWith('http') ? Image.network : Image.asset
                          child: movie.image.startsWith('http') 
                            ? Image.network(
                                movie.image,
                                width: 30.w,
                                height: 36.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 30.w,
                                  height: 36.h,
                                  color: Colors.grey[800],
                                  child: Icon(Icons.broken_image, color: Colors.white54, size: 16),
                                ),
                              )
                            : (movie.image.isEmpty
                                ? Container(
                                    width: 30.w,
                                    height: 36.h,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.broken_image, color: Colors.white54, size: 16),
                                  )
                                : Image.asset(
                                    movie.image,
                                    width: 30.w,
                                    height: 36.h,
                                    fit: BoxFit.cover,
                                  )),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF76212),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4.r),
                                bottomLeft: Radius.circular(4.r),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: "${index + 1}",
                              fontSize: 4.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: movie.title,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            maxLines: 2,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.fire_icon,
                                width: 10.w,
                                height: 10.h,
                              ),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: movie.views,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF76212),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Explore More ",
                  fontSize: 10.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7),
                  size: 10.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindOutMore() {
    final categories = [
      "Hidden Identity",
      "Love After Marriage",
      "Revenge",
      "Age Gap",
    ];
    return Container(
      width: 172.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1817),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF080E26), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF994A24), // orange — top left
            Color(0xFF1B1616), // dark brown — middle
            Color(0xFF000000), // dark brown — middle
          ],
          stops: [0.0, 0.70, 2.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Find Out More",
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF76212),
          ),
          SizedBox(height: 22.h),
          ...categories
              .map(
                (cat) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A2B1E),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: CustomText(
                      text: cat,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSeriesCard({
    required DiscoverMovie movie,
    required String badge,
    required String title,
    required String subtitle,
    required String views,
  }) {
    return GestureDetector(
      onTap: () => controller.playContentDirectly(movie.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: movie.image.startsWith('http') 
                  ? Image.network(
                      movie.image,
                      height: 150.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150.h,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: Icon(Icons.broken_image, color: Colors.white54),
                      ),
                    )
                  : (movie.image.isEmpty
                      ? Container(
                          height: 150.h,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: const Icon(Icons.broken_image, color: Colors.white54),
                        )
                      : Image.asset(
                          movie.image,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
              ),
              // Badge
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
                    text: badge,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              // Views
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 14.sp),
                    SizedBox(width: 2.w),
                    CustomText(
                      text: views,
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: title,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: subtitle,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E8E),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNoContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      alignment: Alignment.center,
      child: CustomText(
        text: "No Content Found",
        fontSize: 14.sp,
        color: Colors.white54,
      ),
    );
  }
}
