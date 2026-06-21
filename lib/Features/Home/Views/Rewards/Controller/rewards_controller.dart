import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Model/rewards_model.dart';
import '../Pages/turn_on_notification_page.dart';
import 'package:uremz100/core/services/rewards_service.dart';
import 'package:uremz100/core/services/storage_service.dart';
import 'package:uremz100/core/services/admob_service.dart';

class RewardsController extends GetxController {
  final RewardsService _rewardsService = Get.find<RewardsService>();
  final StorageService _storageService = Get.find<StorageService>();

  var coinBalance = 0.obs;
  var isLoadingWallet = false.obs;
  var isClaimingCheckIn = false.obs;

  // 7 Days Streak Data
  final RxInt currentStreak = 0.obs;
  var checkedInDays = <int, bool>{}.obs;
  final List<int> streakRewards = [10, 20, 30, 40, 50, 60, 100];
  
  var claimedDuration = 0.obs;

  // Task claims state
  var hasClaimedFacebookReward = false.obs;
  var hasClaimedInstagramReward = false.obs;
  var hasClaimedLoginReward = false.obs;
  var hasClaimedNotificationReward = false.obs;
  var hasClaimedYoutubeReward = false.obs;
  
  var hasNotificationPermission = false.obs;

  // Loading states for tasks
  var isClaimingTask = <String, bool>{}.obs;

  static const String _lastCheckInTimeKey = 'last_successful_check_in_time';
  var canCheckIn = true.obs;
  var checkInRemainingTime = ''.obs;
  Timer? _checkInTimer;

  @override
  void onInit() {
    super.onInit();
    _checkNotificationPermission();
    fetchWalletDetails();
    _checkInTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCheckInStatus();
    });
  }

  @override
  void onClose() {
    _checkInTimer?.cancel();
    super.onClose();
  }

  Future<void> _checkNotificationPermission() async {
    hasNotificationPermission.value = await Permission.notification.isGranted;
    _updateTodayBenefits();
  }

  void _updateCheckInStatus() {
    final lastCheckInStr = _storageService.readData<String>(_lastCheckInTimeKey);
    if (lastCheckInStr != null && lastCheckInStr.isNotEmpty) {
      final lastCheckInTime = DateTime.parse(lastCheckInStr).toUtc();
      final now = DateTime.now().toUtc();
      final difference = now.difference(lastCheckInTime);

      if (difference.inHours < 24) {
        canCheckIn.value = false;
        final remaining = const Duration(hours: 24) - difference;
        checkInRemainingTime.value = _formatDuration(remaining);
      } else {
        canCheckIn.value = true;
        checkInRemainingTime.value = '';
      }
    } else {
      canCheckIn.value = true;
      checkInRemainingTime.value = '';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> claimDailyCheckIn() async {
    isClaimingCheckIn.value = true;
    try {
      final response = await _rewardsService.claimDailyCheckIn();
      if (response['success'] == true) {
        final now = DateTime.now().toUtc();
        _storageService.writeData(_lastCheckInTimeKey, now.toIso8601String());
        _updateCheckInStatus();

        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text(
                response['message'] ?? "Daily check-in reward claimed successfully",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFFF76212),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        fetchWalletDetails();
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to claim check-in reward",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1A1B20),
          colorText: const Color(0xFFEDADA1),
        );
      }
    } catch (e) {
      print("Failed to claim check-in reward: $e");
    } finally {
      isClaimingCheckIn.value = false;
    }
  }

  Future<void> fetchWalletDetails() async {
    isLoadingWallet.value = true;
    try {
      final response = await _rewardsService.fetchWallet();
      if (response['success'] == true) {
        final data = response['data'];
        if (data != null) {
          coinBalance.value = data['coinBalance'] ?? 0;
          
          final progress = data['progress'] ?? {};
          if (progress['checkInRewards'] != null) {
            final Map<String, dynamic> rewardsMap = progress['checkInRewards'];
            int maxClaimedDay = 0;
            for (int i = 1; i <= 7; i++) {
              final dayKey = 'day$i';
              if (rewardsMap[dayKey] != null && rewardsMap[dayKey]['claimed'] == true) {
                checkedInDays[i] = true;
                maxClaimedDay = i;
              } else {
                checkedInDays[i] = false;
              }
            }
            currentStreak.value = maxClaimedDay;
          }

          if (progress['dailyWatchReward'] != null) {
            claimedDuration.value = progress['dailyWatchReward']['claimedDuration'] ?? 0;
          }

          hasClaimedFacebookReward.value = progress['hasClaimedFacebookReward'] ?? false;
          hasClaimedInstagramReward.value = progress['hasClaimedInstagramReward'] ?? false;
          hasClaimedLoginReward.value = progress['hasClaimedLoginReward'] ?? false;
          hasClaimedNotificationReward.value = progress['hasClaimedNotificationReward'] ?? false;
          hasClaimedYoutubeReward.value = progress['hasClaimedYoutubeReward'] ?? false;
          
          _updateTodayBenefits();
        }
      }
    } catch (e) {
      print("Failed to fetch wallet details: $e");
    } finally {
      isLoadingWallet.value = false;
    }
  }

  var isClaimingWatchReward = false.obs;

  Future<void> claimWatchTimeReward({int minutes = 5}) async {
    isClaimingWatchReward.value = true;
    try {
      final response = await _rewardsService.claimWatchTimeReward(minutes);
      if (response['success'] == true) {
        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text(
                "Watch time reward claimed successfully for $minutes minutes!",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFFF76212),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        fetchWalletDetails();
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to claim reward",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1A1B20),
          colorText: const Color(0xFFEDADA1),
        );
      }
    } catch (e) {
      print("Failed to claim watch reward: $e");
    } finally {
      isClaimingWatchReward.value = false;
    }
  }

  void _updateTodayBenefits() {
    for (var i = 0; i < todayBenefits.length; i++) {
      var item = todayBenefits[i];
      if (item.title == "Turn On Notifications") {
        if (hasClaimedNotificationReward.value) {
          item.buttonText = "Claimed";
        } else if (hasNotificationPermission.value) {
          item.buttonText = "Claim";
        } else {
          item.buttonText = "Go";
        }
      } else if (item.title == "Login Rewards") {
        item.buttonText = hasClaimedLoginReward.value ? "Claimed" : "Claim";
      } else if (item.title == "Follow us on Facebook") {
        item.buttonText = hasClaimedFacebookReward.value ? "Claimed" : "Go";
      } else if (item.title == "Follow us on Instragram" || item.title == "Follow us on Instagram") {
        item.buttonText = hasClaimedInstagramReward.value ? "Claimed" : "Go";
      } else if (item.title == "Subscribe to YouTube" || item.title == "Follow us on Youtube") {
        item.buttonText = hasClaimedYoutubeReward.value ? "Claimed" : "Go";
      }
      todayBenefits[i] = item;
    }
    todayBenefits.refresh();
  }

  Future<void> handleTaskAction(String title) async {
    if (isClaimingTask[title] == true) return;

    if (title == "Turn On Notifications") {
      if (hasClaimedNotificationReward.value) return;
      
      if (hasNotificationPermission.value) {
        await _claimTask('NOTIFICATION', title);
      } else {
        Get.to(() => const TurnOnNotificationPage());
      }
    } else if (title == "Login Rewards") {
      if (hasClaimedLoginReward.value) return;
      await _claimTask('LOGIN', title);
    } else if (title == "Follow us on Facebook") {
      if (hasClaimedFacebookReward.value) return;
      final uri = Uri.parse("https://www.facebook.com"); // Placeholder
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        await Future.delayed(const Duration(seconds: 2));
        await _claimTask('FACEBOOK', title);
      }
    } else if (title == "Follow us on Instragram" || title == "Follow us on Instagram") {
      if (hasClaimedInstagramReward.value) return;
      final uri = Uri.parse("https://www.instagram.com"); // Placeholder
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        await Future.delayed(const Duration(seconds: 2));
        await _claimTask('INSTAGRAM', title);
      }
    } else if (title == "Subscribe to YouTube" || title == "Follow us on Youtube") {
      if (hasClaimedYoutubeReward.value) return;
      final uri = Uri.parse("https://www.youtube.com"); // Placeholder
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        await Future.delayed(const Duration(seconds: 2));
        await _claimTask('YOUTUBE', title);
      }
    } else if (title == "Watch Adds(0/12) Get 10 Coins" || title == "Watch Ads, Earn Bonus") {
      isClaimingTask[title] = true;
      isClaimingTask.refresh();
      
      Get.find<AdMobService>().showRewardedAd(
        onRewardEarned: () async {
          // Grant reward via API using generic 'AD_WATCH' task type (or adjust based on actual backend)
          await _claimTask('WATCH_AD', title);
        },
        onAdFailed: () {
          // If the user closed it early or it failed to load
          isClaimingTask[title] = false;
          isClaimingTask.refresh();
        },
      );
    }
  }

  Future<void> _claimTask(String taskType, String title) async {
    isClaimingTask[title] = true;
    isClaimingTask.refresh();
    try {
      final response = await _rewardsService.claimTaskReward(taskType);
      if (response['success'] == true) {
        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text(
                response['message'] ?? "$taskType reward claimed successfully",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFFF76212),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        fetchWalletDetails();
      } else {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to claim reward",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1A1B20),
          colorText: const Color(0xFFEDADA1),
        );
      }
    } catch (e) {
      print("Failed to claim task reward: $e");
    } finally {
      isClaimingTask[title] = false;
      isClaimingTask.refresh();
    }
  }

  // Data using models
  final RxList<RewardStepModel> rewardsSteps = <RewardStepModel>[
    RewardStepModel(coins: "+10", time: "5mins"),
    RewardStepModel(coins: "+15", time: "10mins"),
    RewardStepModel(coins: "+20", time: "20mins"),
    RewardStepModel(coins: "+25", time: "30mins"),
    RewardStepModel(coins: "+30", time: "40mins"),
  ].obs;

  final RxList<BenefitTaskModel> todayBenefits = <BenefitTaskModel>[

    BenefitTaskModel(
      layoutType: "top_coins",
      title: "Turn On Notifications",
      coinsLabel: "30",
      buttonText: "Go",
    ),
    BenefitTaskModel(
      layoutType: "top_coins",
      title: "Watch Ads, Earn Bonus",
      coinsLabel: "10",
      buttonText: "Go",
    ),
    BenefitTaskModel(
      layoutType: "top_coins",
      title: "Login Rewards",
      coinsLabel: "50",
      buttonText: "Claim",
      isHighlight: true,
    ),

    BenefitTaskModel(
      layoutType: "top_coins",
      title: "Follow us on Facebook",
      coinsLabel: "20",
      buttonText: "Go",
    ),

    BenefitTaskModel(
      layoutType: "top_coins",
      title: "Follow us on Instragram",
      coinsLabel: "20",
      buttonText: "Go",
    ),
  ].obs;

  final RxList<String> descriptions = <String>[
    "1. All interpretation rights of bonus belong to Shortmax.",
    "2. Bonus can only be used to watch dramas, valid for 5 days, and will be automatically expired and liquidated after expiration.",
    "3. Gold coins will be used first when watching dramas, If not enough, Bonus will be used automatically.",
  ].obs;
}
