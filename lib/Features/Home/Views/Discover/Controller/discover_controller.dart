import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Models/discrive_models.dart';
import '../Data/discover_data.dart';
import 'package:uremz100/Data/Repositories/home_repository.dart';
import 'package:uremz100/Data/Models/home_content_model.dart';
import 'package:uremz100/core/services/storage_service.dart';
import 'package:uremz100/Data/Repositories/content_details_repository.dart';
import 'package:uremz100/Data/Models/content_details_model.dart';
import 'package:uremz100/Config/routes.dart';
import 'package:uremz100/Domain/UseCases/search_content_usecase.dart';
import 'package:uremz100/Domain/Entities/search_content_entity.dart';
import 'package:uremz100/core/services/rewards_service.dart' as uremz100_rewards;
class DiscoverController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  final ContentDetailsRepository _detailsRepository = Get.find<ContentDetailsRepository>();
  final SearchContentUseCase _searchUseCase = Get.find<SearchContentUseCase>();

  var selectedCategory = 'Popular'.obs;
  var showBonusPopup = false.obs;
  var vipPeriod = 'Daily'.obs;
  var selectedRankingTab = 'Popular'.obs;
  var selectedMovie = Rxn<DiscoverMovie>(); // Selected movie for popup
  var showMoviePopup = false.obs; // Toggle movie popup visibility
  var showLoginPopup = false.obs; // Toggle login popup visibility
  static bool _hasShownInitialPopups = false;

  late ScrollController popularScrollController;
  Timer? _marqueeTimer;
  Timer? _checkInTimer;

  static const String _lastCheckInTimeKey = 'last_successful_check_in_time';

  var canCheckIn = true.obs;
  var checkInRemainingTime = ''.obs;

  final List<String> categories = DiscoverData.categories;
  final List<DiscoverMovie> allMovies = DiscoverData.allMovies;
  final List<BonusItem> dailyBonus = DiscoverData.dailyBonus;

  // New API State
  // Popular API State
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // New Tab API State
  var isNewLoading = false.obs;
  var hasNewError = false.obs;
  var newErrorMessage = ''.obs;
  var newSections = <HomeSection>[].obs;

  // VIP Tab API State
  var isVipLoading = false.obs;
  var hasVipError = false.obs;
  var vipErrorMessage = ''.obs;
  var vipSections = <HomeSection>[].obs;

  // Dynamic Lists mapped to DiscoverMovie for Popular Tab
  var trendingMovies = <DiscoverMovie>[].obs;
  var seriesMovies = <DiscoverMovie>[].obs;
  var continueWatchingMovies = <DiscoverMovie>[].obs;
  var youMightLikeMovies = <DiscoverMovie>[].obs;
  var topPicksMovies = <DiscoverMovie>[].obs;

  // Search API State
  var isSearching = false.obs;
  var searchResults = <SearchContentEntity>[].obs;
  var searchTerm = ''.obs;
  var searchMeta = Rxn<Map<String, dynamic>>();
  var isSearchLoading = false.obs;
  var searchErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    popularScrollController = ScrollController();
    _startMarquee();
    _initCheckInState();
    fetchHomeContent();

    debounce(searchTerm, (_) {
      if (searchTerm.value.trim().isEmpty) {
        isSearching.value = false;
        searchResults.clear();
        searchErrorMessage.value = '';
      } else {
        isSearching.value = true;
        _performSearch(searchTerm.value.trim());
      }
    }, time: const Duration(milliseconds: 500));
  }

  void onSearchChanged(String query) {
    searchTerm.value = query;
  }

  Future<void> _performSearch(String query) async {
    isSearchLoading.value = true;
    searchErrorMessage.value = '';

    final response = await _searchUseCase.execute(query);

    if (response.isSuccess && response.data != null) {
      final searchResponse = response.data!;
      if (searchResponse.data != null) {
        searchResults.value = searchResponse.data!.map((e) => e.toEntity()).toList();
      } else {
        searchResults.clear();
      }
      if (searchResponse.meta != null) {
        searchMeta.value = {
          'total': searchResponse.meta!.total,
          'limit': searchResponse.meta!.limit,
          'page': searchResponse.meta!.page,
          'totalPages': searchResponse.meta!.totalPages,
          'hasNext': searchResponse.meta!.hasNext,
          'hasPrev': searchResponse.meta!.hasPrev,
        };
      }
    } else {
      searchErrorMessage.value = response.message;
      searchResults.clear();
    }
    isSearchLoading.value = false;
  }

  Future<void> fetchHomeContent() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final response = await _homeRepository.getHomeContent('popular');

    if (response.isSuccess && response.data != null) {
      _mapSectionsToState(response.data!.sections);
    } else {
      hasError.value = true;
      errorMessage.value = response.message;
    }
    
    isLoading.value = false;
  }

  Future<void> fetchNewContent() async {
    isNewLoading.value = true;
    hasNewError.value = false;
    newErrorMessage.value = '';

    final response = await _homeRepository.getHomeContent('new');

    if (response.isSuccess && response.data != null) {
      newSections.value = response.data!.sections;
    } else {
      hasNewError.value = true;
      newErrorMessage.value = response.message;
    }
    
    isNewLoading.value = false;
  }

  Future<void> refreshData() async {
    if (selectedCategory.value == 'Popular') {
      await fetchHomeContent();
    } else if (selectedCategory.value == 'New') {
      await fetchNewContent();
    } else if (selectedCategory.value == 'VIP') {
      await fetchVipContent(vipPeriod.value.toLowerCase());
    }
    // For other tabs, add fetch calls as they are implemented
  }

  Future<void> fetchVipContent(String filter) async {
    isVipLoading.value = true;
    hasVipError.value = false;
    vipErrorMessage.value = '';

    final response = await _homeRepository.getHomeContent('vip', filter: filter);

    if (response.isSuccess && response.data != null) {
      vipSections.value = response.data!.sections;
    } else {
      hasVipError.value = true;
      vipErrorMessage.value = response.message;
    }
    
    isVipLoading.value = false;
  }

  void _mapSectionsToState(List<HomeSection> sections) {
    trendingMovies.clear();
    seriesMovies.clear();
    continueWatchingMovies.clear();
    youMightLikeMovies.clear();
    topPicksMovies.clear();

    for (var section in sections) {
      final mappedItems = section.items.map((item) => DiscoverMovie(
        id: item.id.toString(),
        title: item.title,
        subtitle: item.contentType,
        image: item.posterUrl,
        badge: item.isRecent ? 'New' : null,
        views: item.rating.toString(),
        categories: ['Popular'],
      )).toList();

      switch (section.type) {
        case 'TRENDING':
          trendingMovies.addAll(mappedItems);
          break;
        case 'SERIES':
          seriesMovies.addAll(mappedItems);
          break;
        case 'CONTINUE_WATCHING':
          continueWatchingMovies.addAll(mappedItems);
          break;
        case 'YOU_MIGHT_LIKE':
          youMightLikeMovies.addAll(mappedItems);
          break;
        case 'TOP_PICKS':
          topPicksMovies.addAll(mappedItems);
          break;
      }
    }
  }

  void _startMarquee() {
    _marqueeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (popularScrollController.hasClients) {
        double maxScroll = popularScrollController.position.maxScrollExtent;
        double currentScroll = popularScrollController.offset;

        if (currentScroll >= maxScroll) {
          // Go back to start
          popularScrollController.jumpTo(0);
        } else {
          // Slide by exactly 3 items (120w item * 3 = 360w)
          popularScrollController.animateTo(
            currentScroll + 360.w,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Trigger popups on first load
    if (!_hasShownInitialPopups) {
      if (allMovies.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          openMoviePopup(allMovies.first);
          _hasShownInitialPopups = true;
        });
      }
    }
  }

  void openMoviePopup(DiscoverMovie movie) {
    selectedMovie.value = movie;
    showMoviePopup.value = true;
  }

  bool get isLoggedIn {
    try {
      final token = Get.find<StorageService>().getToken();
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void closeMoviePopup() {
    showMoviePopup.value = false;
    // Skip login popup and directly trigger the next sequence
    Future.delayed(const Duration(milliseconds: 500), () {
      closeLoginPopup();
    });
  }

  void closeLoginPopup() {
    showLoginPopup.value = false;
    // After 1 second, show bonus popup
    Future.delayed(const Duration(seconds: 1), () {
      showBonusPopup.value = true;
    });
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    if (category == 'New' && (newSections.isEmpty || hasNewError.value)) {
      fetchNewContent();
    } else if (category == 'VIP' && (vipSections.isEmpty || hasVipError.value)) {
      fetchVipContent(vipPeriod.value.toLowerCase());
    }
  }

  void changeVipPeriod(String period) {
    if (vipPeriod.value != period) {
      vipPeriod.value = period;
      fetchVipContent(period.toLowerCase());
    }
  }

  List<DiscoverMovie> get vipMovies {
    final period = vipPeriod.value;
    if (period == 'Daily') {
      return allMovies.take(6).toList();
    } else if (period == 'Weekly') {
      return allMovies.skip(3).take(6).toList();
    }
    return allMovies.take(6).toList();
  }

  void changeRankingTab(String tab) {
    selectedRankingTab.value = tab;
  }

  List<DiscoverMovie> get filteredMovies {
    if (selectedCategory.value == 'Popular') {
      return allMovies;
    }
    return allMovies
        .where((movie) => movie.categories.contains(selectedCategory.value))
        .toList();
  }

  List<DiscoverMovie> get rankingMovies {
    final tab = selectedRankingTab.value;

    if (tab == 'Popular') {
      return allMovies.where((m) => m.categories.contains('Popular')).toList();
    } else if (tab == 'Daily Top') {
      return allMovies
          .where(
            (m) => m.categories.contains('Daily Top') || m.views.contains('M'),
          )
          .toList();
    } else if (tab == 'Weekly Top') {
      return allMovies
          .where((m) => m.categories.contains('Weekly Top') || m.isVip)
          .toList();
    } else if (tab == 'Monthly Top') {
      return allMovies
          .where((m) => m.categories.contains('Monthly Top') || m.badge != null)
          .toList();
    }

    return allMovies;
  }

  void closePopup() {
    showBonusPopup.value = false;
  }

  Future<void> claimCheckIn() async {
    try {
      final rewardsService = Get.find<uremz100_rewards.RewardsService>();
      final response = await rewardsService.claimDailyCheckIn();

      if (response['success'] == true) {
        _saveCheckInSuccess();
        final data = response['data'];
        Get.snackbar(
          "Success",
          "Claimed ${data['coinsEarned']} coins. Streak: ${data['streakDay']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        closePopup();
      } else {
        Get.snackbar(
          "Notice",
          response['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to claim check-in",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  var isPlayingDirectly = false.obs;

  Future<void> playContentDirectly(String contentId) async {
    Get.toNamed(Routes.movieDetailScreen, arguments: {'movieId': contentId});
  }

  @override
  void onClose() {
    _marqueeTimer?.cancel();
    _checkInTimer?.cancel();
    popularScrollController.dispose();
    super.onClose();
  }

  void _initCheckInState() {
    _updateCheckInStatus();
    _checkInTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!canCheckIn.value) {
        _updateCheckInStatus();
      }
    });
  }

  void _updateCheckInStatus() {
    final storage = Get.find<StorageService>();
    final lastCheckInStr = storage.readData<String>(_lastCheckInTimeKey);
    if (lastCheckInStr != null) {
      final lastCheckIn = DateTime.parse(lastCheckInStr).toUtc();
      final now = DateTime.now().toUtc();
      final difference = now.difference(lastCheckIn);
      if (difference.inHours < 24) {
        canCheckIn.value = false;
        final remaining = const Duration(hours: 24) - difference;
        final h = remaining.inHours.toString().padLeft(2, '0');
        final m = (remaining.inMinutes % 60).toString().padLeft(2, '0');
        final s = (remaining.inSeconds % 60).toString().padLeft(2, '0');
        checkInRemainingTime.value = "$h:$m:$s";
      } else {
        canCheckIn.value = true;
        checkInRemainingTime.value = '';
      }
    } else {
      canCheckIn.value = true;
      checkInRemainingTime.value = '';
    }
  }

  void _saveCheckInSuccess() {
    final storage = Get.find<StorageService>();
    // If API returns timestamp, it could be read here. We use local UTC.
    storage.writeData(_lastCheckInTimeKey, DateTime.now().toUtc().toIso8601String());
    _updateCheckInStatus();
  }
}
