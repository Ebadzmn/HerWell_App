import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Features/Home/Views/Shorts/More/Widget/more_widget.dart';
import 'package:uremz100/Features/Home/Views/Shorts/More/Modet/more_model.dart';
import 'package:uremz100/Utils/app_images.dart';
import '../Controller/movie_details_player_controller.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String movieId = args?['movieId'] ?? '';
    final int startSeconds = args?['startSeconds'] ?? 0;

    final controller = Get.put(
      MovieDetailsPlayerController(
        movieId: movieId,
        startSeconds: startSeconds,
      ),
      tag: movieId,
    );

    return WillPopScope(
      onWillPop: () async {
        if (controller.isFullscreen.value) {
          controller.toggleFullscreen();
          return false;
        }
        controller.triggerPipAndClose();
        return false; // Prevent default pop since triggerPipAndClose handles Get.back()
      },
      child: Obx(() {
        if (controller.isFullscreen.value) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(child: _buildVideoPlayerSection(controller)),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF141414),
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => controller.triggerPipAndClose(),
            ),
            title: const Text('Details', style: TextStyle(color: Colors.white)),
          ),
          body: Column(
            children: [
              _buildVideoPlayerSection(controller),
              Expanded(child: _buildMovieDetailsSection(controller)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVideoPlayerSection(MovieDetailsPlayerController controller) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio:
            controller.isVideoInitialized.value &&
                controller.videoPlayerController != null
            ? controller.videoPlayerController!.value.aspectRatio
            : 16 / 9,
        child:
            controller.isVideoInitialized.value &&
                controller.videoPlayerController != null
            ? GestureDetector(
                onTap: controller.toggleControls,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(controller.videoPlayerController!),
                    if (controller.showControls.value) ...[
                      Container(color: Colors.black38), // Dim background
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 48,
                            ),
                            onPressed: controller.togglePlayPause,
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            VideoProgressIndicator(
                              controller.videoPlayerController!,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              colors: const VideoProgressColors(
                                playedColor: Color(0xFFE8124C),
                                bufferedColor: Colors.white24,
                                backgroundColor: Colors.white12,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ).copyWith(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${controller.formatDuration(controller.videoPosition.value)} / ${controller.formatDuration(controller.videoDuration.value)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      controller.isFullscreen.value
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                    onPressed: controller.toggleFullscreen,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (controller.isBuffering.value)
                      const CircularProgressIndicator(color: Color(0xFFE8124C)),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(color: Color(0xFFE8124C)),
              ),
      ),
    );
  }

  Widget _buildMovieDetailsSection(MovieDetailsPlayerController controller) {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE8124C)),
      );
    }

    if (controller.hasError.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: controller.errorMessage.value,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.fetchMovieDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final movie = controller.movieDetails;
    if (movie == null) return const SizedBox.shrink();

    // Sample Data for Related Content
    final List<RelatedContentModel> relatedList = [
      RelatedContentModel(
        title: "Ms. CEO's Baby Daddy Is the...",
        category: "Flash Marriage",
        views: "300.4M",
        imageUrl: AppImages.move_1,
      ),
      RelatedContentModel(
        title: "Breathe",
        category: "First Love",
        views: "48.9M",
        imageUrl: AppImages.move_2,
      ),
      RelatedContentModel(
        title: "My Sister Is the Warlord Queen",
        category: "Hidden Identity",
        views: "531.8M",
        imageUrl: AppImages.move_3,
      ),
      RelatedContentModel(
        title: "Scandalous",
        category: "Enemies to Lovers",
        views: "27.5M",
        imageUrl: AppImages.move_4,
        isNew: true,
      ),
      RelatedContentModel(
        title: "The Cooking Queen: A Reci...",
        category: "Contract Lovers",
        views: "29.3M",
        imageUrl: AppImages.move_5,
      ),
      RelatedContentModel(
        title: "Pucked in the Friend Zone",
        category: "Fake Relationship",
        views: "14.4M",
        imageUrl: AppImages.move_6,
        isNew: true,
      ),
      RelatedContentModel(
        title: "In the Palm of His Hand",
        category: "Love-Hate",
        views: "110.7M",
        imageUrl: AppImages.move_7,
      ),
      RelatedContentModel(
        title: "In Love with a Single Farm...",
        category: "Flash Marriage",
        views: "224.2M",
        imageUrl: AppImages.move_2,
      ),
      RelatedContentModel(
        title: "Bound by Honor",
        category: "First Love",
        views: "366.3M",
        imageUrl: AppImages.move_3,
      ),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: movie.posterUrl.isNotEmpty
                    ? Image.network(
                        movie.posterUrl,
                        width: 72.w,
                        height: 96.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              AppImages.move_1,
                              width: 72.w,
                              height: 96.h,
                              fit: BoxFit.cover,
                            ),
                      )
                    : Image.asset(
                        AppImages.move_1,
                        width: 72.w,
                        height: 96.h,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: movie.title,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    SizedBox(height: 4.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: controller.formatViews(movie.views),
                          fontSize: 12.sp,
                          color: const Color(0xFF8E8E8E),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 12.sp),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: movie.rating.toStringAsFixed(1),
                              fontSize: 12.sp,
                              color: const Color(0xFF8E8E8E),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: "${movie.duration} min • ${movie.releaseYear}",
                          fontSize: 12.sp,
                          color: const Color(0xFF8E8E8E),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              MoreScreenWidgets.buildTag(movie.type),
              SizedBox(width: 8.w),
              MoreScreenWidgets.buildTag("Original"),
            ],
          ),
          SizedBox(height: 24.h),
          MoreScreenWidgets.buildSectionTitle("Synopsis"),
          CustomText(
            text: movie.description,
            fontSize: 12.sp,
            color: const Color(0xFFB3B3B3),
          ),
          SizedBox(height: 24.h),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: controller.addToMyList,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF292929),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.bookmark_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: "Add to My List",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (movie.trailerUrl.isNotEmpty) ...[
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: controller.playTrailerAsShort,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 20,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: "Trailer",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (movie.type == 'SERIES') ...[
            SizedBox(height: 32.h),
            MoreScreenWidgets.buildSectionTitle("Seasons"),
            CustomText(
              text: "Total Seasons: ${movie.seasonsCount} • Total Episodes: ${movie.totalEpisodes}",
              fontSize: 12.sp,
              color: const Color(0xFFB3B3B3),
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: "Total Watch Time: ${movie.totalWatchTime} min",
              fontSize: 12.sp,
              color: const Color(0xFFB3B3B3),
            ),
            SizedBox(height: 16.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  if (movie.trailerUrl.isNotEmpty) ...[
                    Container(
                      width: 68.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        text: "Trailer",
                        fontSize: 13.sp,
                        color: const Color(0xFF8E8E8E),
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                  ...movie.seasons.map((season) {
                    final isSelected = controller.selectedSeasonId.value == season.id;
                    return GestureDetector(
                      onTap: () => controller.selectSeason(season.id),
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Container(
                          height: 48.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE8124C).withOpacity(0.1) : const Color(0xFF222222),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFE8124C) : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: CustomText(
                            text: season.title,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? const Color(0xFFE8124C) : const Color(0xFF8E8E8E),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            if (controller.isLoadingEpisodes.value) ...[
              SizedBox(height: 24.h),
              const Center(child: CircularProgressIndicator(color: Color(0xFFE8124C))),
            ] else if (controller.episodes.isNotEmpty) ...[
              SizedBox(height: 16.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.episodes.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final episode = controller.episodes[index];
                  return GestureDetector(
                    onTap: () {
                      if (episode.requiredCoin > 0) {
                        Get.snackbar(
                          "Locked", 
                          "This episode requires ${episode.requiredCoin} coins to unlock",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      controller.playEpisode(episode);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(8.r)),
                            child: Image.network(
                              episode.thumbnailUrl.isNotEmpty ? episode.thumbnailUrl : AppImages.move_1,
                              width: 120.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                AppImages.move_1,
                                width: 120.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: episode.title,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    text: "${episode.duration} min",
                                    fontSize: 12.sp,
                                    color: const Color(0xFF8E8E8E),
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    text: episode.description,
                                    fontSize: 12.sp,
                                    color: const Color(0xFFB3B3B3),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Icon(
                              episode.requiredCoin > 0 ? Icons.lock : Icons.play_circle_outline, 
                              color: episode.requiredCoin > 0 ? const Color(0xFFF76212) : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
          SizedBox(height: 32.h),
          MoreScreenWidgets.buildSectionTitle("More Like This"),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 24.h,
              childAspectRatio: 0.48,
            ),
            itemCount: relatedList.length,
            itemBuilder: (context, index) {
              final related = relatedList[index];
              return MoreScreenWidgets.buildRelatedItem(
                related.title,
                related.category,
                related.views,
                related.imageUrl,
                related.isNew,
              );
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
