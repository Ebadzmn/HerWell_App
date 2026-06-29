import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uremz100/Features/Home/Controllers/pip_controller.dart';
import 'package:uremz100/Shared/Widgets/Custom_Text.dart';
import 'package:uremz100/Utils/app_colors.dart';
import 'package:uremz100/Utils/app_images.dart';
import '../Model/shorts_model.dart';
import '../../Bottom_NabBar/Controller/Bottom_NabBar_Controller.dart';
import 'Shorts_Video_Controller.dart';
import 'package:uremz100/core/services/storage_service.dart';

import '../More/more_screen.dart';
import 'dart:async';
import 'package:uremz100/Data/Datasources/Remote/shorts_remote_datasource.dart';
import 'package:uremz100/Data/Repositories/shorts_repository.dart';
import 'package:uremz100/Domain/UseCases/get_shorts_usecase.dart';
import 'package:uremz100/Domain/UseCases/track_short_view_usecase.dart';
import 'package:uremz100/Domain/UseCases/add_to_collection_usecase.dart';
import 'package:uremz100/Data/Repositories/content_details_repository.dart';
import 'package:uremz100/Data/Models/content_details_model.dart';

class ShortsController extends GetxController {
  var shortsList = <ShortsModel>[].obs;
  var isFav = false.obs;
  var savedIds = <String>{}.obs;
  var showLoginPopup = false.obs;
  var showMoreMenu = false.obs;
  var currentEpisode = 4.obs;
  var currentSeason = 2.obs;
  var isPipEnabled = true.obs;
  var playbackSpeed = "1.0x".obs;
  var videoQuality = "1080p".obs;
  var isDescriptionExpanded = false.obs;
  var showEpisodePopup = false.obs;
  var selectedEpisodeRange = "1-25".obs;
  var isFullSeriesMode = false.obs;
  var currentIndex = 0.obs;
  var showRewardIcon = true.obs;

  // Pagination State
  String? nextCursor;
  bool hasNextPage = true;
  var isPaginationLoading = false.obs;
  var isInitialLoading = false.obs;

  // View Tracking State
  Set<String> trackedViews = {};
  Timer? _viewTimer;

  // Content Details State
  var isLoadingDetails = false.obs;
  var currentContentDetails = Rxn<ContentDetailsModel>();
  var episodes = <EpisodeModel>[].obs;
  var selectedSeasonId = ''.obs;

  // Use Cases
  late final GetShortsUseCase _getShortsUseCase;
  late final TrackShortViewUseCase _trackShortViewUseCase;
  late final AddToCollectionUseCase _addToCollectionUseCase;
  late final ContentDetailsRepository _contentDetailsRepository;

  void showMoreDetailsBottomSheet() {
    pauseCurrentVideo();
    final String currentMovieId = shortsList.isNotEmpty ? shortsList[currentIndex.value].id : '';
    Get.bottomSheet(
      MoreScreen(movieId: currentMovieId),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).then((_) {
      playCurrentVideo();
    });
  }

  @override
  void onInit() {
    super.onInit();
    
    // Initialize Use Cases
    final dataSource = ShortsRemoteDataSource();
    final repository = ShortsRepository(dataSource);
    _getShortsUseCase = GetShortsUseCase(repository);
    _trackShortViewUseCase = TrackShortViewUseCase(repository);
    _addToCollectionUseCase = AddToCollectionUseCase(repository);
    _contentDetailsRepository = Get.find<ContentDetailsRepository>();

    if (Get.arguments != null && Get.arguments is Map && (Get.arguments as Map).containsKey('playbackUrl')) {
      handleArguments(Get.arguments);
    } else {
      fetchShorts();
    }

    // Listen to index changes to trigger view tracking and details fetching
    ever(currentIndex, (int index) {
      if (shortsList.isNotEmpty && index < shortsList.length) {
        _startViewTracking(shortsList[index].id);
        fetchSeriesDetails(shortsList[index].id);
        
        // Trigger load more if we are nearing the end
        if (index >= shortsList.length - 2) {
          loadMoreShorts();
        }
      }
    });
  }

  void handleArguments(dynamic arguments) {
    if (arguments != null && arguments is Map && arguments.containsKey('playbackUrl')) {
      final args = arguments;
      final playbackUrl = args['playbackUrl'] as String;
      final title = args['title'] as String? ?? 'Movie Playback';
      final description = args['description'] as String? ?? '';
      final posterUrl = args['posterUrl'] as String? ?? '';
      final contentId = args['contentId'] as String? ?? '';

      final singleMovie = ShortsModel(
        id: contentId,
        videoUrl: playbackUrl,
        posterUrl: posterUrl,
        title: title,
        description: description,
        episode: '1',
        season: '1',
      );
      
      pauseCurrentVideo();
      shortsList.assignAll([singleMovie]);
      currentIndex.value = 0;
      isInitialLoading(false);
      
      _startViewTracking(contentId);
      fetchSeriesDetails(contentId);
    }
  }

  @override
  void onClose() {
    _viewTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchShorts() async {
    try {
      isInitialLoading(true);
      final response = await _getShortsUseCase.execute(limit: 5);
      shortsList.assignAll(response.data);
      if (response.meta != null) {
        nextCursor = response.meta!.nextCursor;
        hasNextPage = response.meta!.hasNextPage;
      }
      if (shortsList.isNotEmpty) {
        _startViewTracking(shortsList.first.id);
        fetchSeriesDetails(shortsList.first.id);
      }
    } catch (e) {
      debugPrint("Error fetching shorts: $e");
    } finally {
      isInitialLoading(false);
    }
  }

  Future<void> fetchSeriesDetails(String shortId) async {
    try {
      isLoadingDetails.value = true;
      final response = await _contentDetailsRepository.getContentDetails(shortId);
      if (response.isSuccess && response.data != null) {
        currentContentDetails.value = response.data;
        if (currentContentDetails.value!.type == 'SERIES' && currentContentDetails.value!.seasons.isNotEmpty) {
          selectSeason(currentContentDetails.value!.seasons.first.id);
        }
      }
    } catch (e) {
      debugPrint("Error fetching series details: $e");
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void selectSeason(String seasonId) {
    if (selectedSeasonId.value == seasonId) return;
    selectedSeasonId.value = seasonId;
    fetchEpisodes(seasonId);
  }

  Future<void> fetchEpisodes(String seasonId) async {
    final response = await _contentDetailsRepository.getSeasonEpisodes(seasonId);
    if (response.isSuccess && response.data != null) {
      episodes.assignAll(response.data!);
    } else {
      episodes.clear();
    }
  }

  Future<void> loadMoreShorts() async {
    if (!hasNextPage || isPaginationLoading.value || isInitialLoading.value) return;

    try {
      isPaginationLoading(true);
      final response = await _getShortsUseCase.execute(limit: 5, cursor: nextCursor);
      shortsList.addAll(response.data);
      if (response.meta != null) {
        nextCursor = response.meta!.nextCursor;
        hasNextPage = response.meta!.hasNextPage;
      }
    } catch (e) {
      debugPrint("Error loading more shorts: $e");
    } finally {
      isPaginationLoading(false);
    }
  }

  void _startViewTracking(String shortId) {
    _viewTimer?.cancel();
    
    // Only track if not already tracked
    if (trackedViews.contains(shortId)) return;

    _viewTimer = Timer(const Duration(seconds: 3), () {
      trackView(shortId);
    });
  }

  Future<void> trackView(String shortId) async {
    if (trackedViews.contains(shortId)) return;
    
    trackedViews.add(shortId); // Add optimistic to prevent multiple requests
    final success = await _trackShortViewUseCase.execute(shortId);
    if (!success) {
      trackedViews.remove(shortId); // Revert if failed
    }
  }

  Future<void> addToCollection(String shortId) async {
    try {
      // Show loading (you can use a dialog or local state, here we just toggle locally if optimistic is needed)
      // We will actually just toggle it for now, and show a snackbar on success
      savedIds.add(shortId); 
      
      final success = await _addToCollectionUseCase.execute(shortId);
      if (success) {
        Get.snackbar(
          "Success", 
          "Added to Collection Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        savedIds.remove(shortId); // Revert
        Get.snackbar(
          "Error", 
          "Failed to add to collection",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      savedIds.remove(shortId); // Revert
    }
  }

  void toggleEpisodePopup() {
    showEpisodePopup.value = !showEpisodePopup.value;
  }

  void changeEpisodeRange(String range) {
    selectedEpisodeRange.value = range;
  }

  List<int> get episodesForSelectedRange {
    final range = selectedEpisodeRange.value;
    if (range == "1-25") {
      return List.generate(25, (i) => i + 1);
    } else if (range == "26-43") {
      return List.generate(18, (i) => i + 26);
    } else if (range == "44-93") {
      return List.generate(50, (i) => i + 44);
    }
    return [];
  }

  void selectEpisode(EpisodeModel episode) {
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

    if (episode.videoUrl.isEmpty) {
      Get.snackbar(
        "Error",
        "Video not available for this episode",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    currentEpisode.value = episode.episodeNumber;
    showEpisodePopup.value = false;

    if (shortsList.isEmpty) return;

    // Pause current playing video
    pauseCurrentVideo();

    final currentIndexValue = currentIndex.value;
    final currentShort = shortsList[currentIndexValue];

    // Create new ShortsModel for this episode
    final newShort = ShortsModel(
      id: episode.id,
      videoUrl: episode.videoUrl,
      posterUrl: episode.thumbnailUrl.isNotEmpty ? episode.thumbnailUrl : currentShort.posterUrl,
      title: episode.title.isNotEmpty ? episode.title : currentShort.title,
      description: episode.description.isNotEmpty ? episode.description : currentShort.description,
      episode: episode.episodeNumber.toString(),
      season: episode.seasonNumber.toString(),
      profileImage: currentShort.profileImage,
      tags: currentShort.tags,
    );

    // Replace in list to trigger video change
    shortsList[currentIndexValue] = newShort;
    shortsList.refresh();

    // Start view tracking for new episode
    _startViewTracking(episode.id);
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
    print("Description expanded: ${isDescriptionExpanded.value}");
  }

  void updatePlaybackSpeed(String speed) {
    playbackSpeed.value = speed;
  }

  void updateVideoQuality(String quality) {
    videoQuality.value = quality;
  }

  bool get isLoggedIn {
    try {
      final token = Get.find<StorageService>().getToken();
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void toggleFav() {
    isFav.value = !isFav.value;
    if (isFav.value && !isLoggedIn) {
      showLoginPopup.value = true;
    }
  }

  void toggleLoginPopup() {
    showLoginPopup.value = !showLoginPopup.value;
  }

  void toggleMoreMenu() {
    showMoreMenu.value = !showMoreMenu.value;
  }

  void togglePip() {
    isPipEnabled.value = !isPipEnabled.value;
  }

  void toggleFullSeriesMode() {
    isFullSeriesMode.value = !isFullSeriesMode.value;
    try {
      final navController = Get.find<NavigationController>();
      navController.toggleBottomNav(!isFullSeriesMode.value);
    } catch (e) {
      // In case NavigationController is not found (e.g. direct screen load)
    }
  }

  void pauseCurrentVideo() {
    try {
      final shortId = shortsList[currentIndex.value].id;
      if (Get.isRegistered<ShortsVideoController>(tag: shortId)) {
        final videoController = Get.find<ShortsVideoController>(tag: shortId);
        videoController.pauseVideo();
      }
    } catch (e) {
      // Index out of range or controller not found
    }
  }

  void playCurrentVideo() {
    try {
      final shortId = shortsList[currentIndex.value].id;
      if (Get.isRegistered<ShortsVideoController>(tag: shortId)) {
        final videoController = Get.find<ShortsVideoController>(tag: shortId);
        videoController.playVideo();
      }
    } catch (e) {
      // Index out of range or controller not found
    }
  }

  void triggerPip() {
    if (shortsList.isNotEmpty) {
      final activeShort = shortsList[currentIndex.value];
      Duration? currentPos;
      try {
        if (Get.isRegistered<ShortsVideoController>(tag: activeShort.id)) {
          final videoController = Get.find<ShortsVideoController>(tag: activeShort.id);
          currentPos = videoController.position.value;
        }
      } catch (e) {}
      try {
        PipController.to.showPip(activeShort, startPosition: currentPos);
      } catch (e) {}
    }
  }

  void exitFullSeries() {
    triggerPip();
    pauseCurrentVideo(); // Pause before going back
    isFullSeriesMode.value = false;
    try {
      final navController = Get.find<NavigationController>();
      navController.toggleBottomNav(true);
    } catch (e) {
      // NavigationController not found
    }
    Get.back();
  }

  void showPlaybackSpeedBottomSheet(String shortId) {
    if (!Get.isRegistered<ShortsVideoController>(tag: shortId)) return;
    final videoController = Get.find<ShortsVideoController>(tag: shortId);
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Playback Speed",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            SizedBox(height: 20.h),
            ...speeds.map(
              (speed) => ListTile(
                title: Center(
                  child: Obx(
                    () => CustomText(
                      text: speed == 1.0 ? "Normal" : "${speed}x",
                      fontSize: 16.sp,
                      color: videoController.playbackSpeed.value == speed
                          ? AppColors.yellow100
                          : Colors.white,
                      fontWeight: videoController.playbackSpeed.value == speed
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                onTap: () {
                  videoController.setPlaybackSpeed(speed);
                  Get.back();
                },
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
