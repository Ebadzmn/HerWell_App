
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'dart:io';

class AdMobService extends GetxService {
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoading = false;

  // Google Test Ad Unit IDs for Rewarded Ads
  final String _rewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  void onInit() {
    super.onInit();
    _initAdMob();
  }

  Future<void> _initAdMob() async {
    await MobileAds.instance.initialize();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    if (_isRewardedAdLoading || _rewardedAd != null) {
      return;
    }
    _isRewardedAdLoading = true;
    
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _isRewardedAdLoading = false;
        },
      ),
    );
  }

  void showRewardedAd({
    required Function onRewardEarned,
    required Function onAdFailed,
  }) {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      onAdFailed();
      // Try loading again for next time
      _loadRewardedAd();
      return;
    }

    final currentAd = _rewardedAd!;
    _rewardedAd = null; // Clear global reference so it can't be shown again

    currentAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _loadRewardedAd(); // Load a new ad immediately after the old one is closed
        onAdFailed(); // If they dismissed without earning, we call failed/closed
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        onAdFailed();
        _loadRewardedAd();
      },
    );

    currentAd.setImmersiveMode(true);
    currentAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      // The user finished the video! Execute the reward callback
      onRewardEarned();
      
      // Override onAdDismissedFullScreenContent so it doesn't call onAdFailed()
      // after they already earned the reward and are just closing the success screen
      currentAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewardedAd();
        },
      );
    });
  }
}
