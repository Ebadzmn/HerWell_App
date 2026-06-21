import 'package:get/get.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'package:uremz100/Utils/app_images.dart';
import '../Model/standart_vip_model.dart';

class StandartVipController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  // void changeTab(int index) {
  //   selectedTabIndex.value = index;
  // }

  final List<VipPlanModel> standardPlans = [
    VipPlanModel(
      title: "Weekly Pass Pro",
      price: "1,500",
      features: [
        VipFeatureModel(
          label: "Short Drama Viewing",
          iconPath: AppIcons.drama_icon,
        ),
        VipFeatureModel(label: "Ad-Free", iconPath: AppIcons.ad_free_icon),
        VipFeatureModel(
          label: "Daily VIP Reward",
          iconPath: AppIcons.rewards_icon,
        ),
        VipFeatureModel(
          label: "1080p Full HD",
          iconPath: AppIcons.full_hd_icon,
        ),
      ],
    ),
    VipPlanModel(
      title: "Monthly Pass Pro",
      price: "2,500",
      features: [
        VipFeatureModel(
          label: "Short Drama Viewing",
          iconPath: AppIcons.drama_icon,
        ),
        VipFeatureModel(label: "Ad-Free", iconPath: AppIcons.ad_free_icon),
        VipFeatureModel(
          label: "Daily VIP Reward",
          iconPath: AppIcons.rewards_icon,
        ),
        VipFeatureModel(
          label: "1080p Full HD",
          iconPath: AppIcons.full_hd_icon,
        ),
      ],
    ),
    VipPlanModel(
      title: "Yearly VIP",
      price: "4,500",
      badge: "Most Popular",
      features: [
        VipFeatureModel(
          label: "Short Drama Viewing",
          iconPath: AppIcons.drama_icon,
        ),
        VipFeatureModel(
          label: "Offline Download",
          iconPath: AppIcons.download_two_icon,
        ),
        VipFeatureModel(
          label: "Daily VIP Reward",
          iconPath: AppIcons.rewards_icon,
        ),
        VipFeatureModel(
          label: "1080p Full HD",
          iconPath: AppIcons.full_hd_icon,
        ),
      ],
    ),
  ];

  final List<MovieModel> bestMovies = [
    MovieModel(
      image: AppImages.move_1,
      title: "Crimson Chars",
      subtitle: "Exclusive",
      views: "3.1M",
      badge: "VIP",
    ),
    MovieModel(
      image: AppImages.move_2,
      title: "Crimson Chars",
      subtitle: "Revenge",
      views: "5.1M",
      badge: "VIP",
    ),
    MovieModel(
      image: AppImages.move_3,
      title: "Mega",
      subtitle: "New Day",
      views: "12.1M",
      badge: "VIP",
    ),
  ];

  final List<MovieModel> comingSoonMovies = [
    MovieModel(
      image: AppImages.move_4,
      title: "Crimson Chars",
      subtitle: "Exclusive",
      views: "3.1M",
      badge: "1 March",
    ),
    MovieModel(
      image: AppImages.move_5,
      title: "Crimson Chars",
      subtitle: "Revenge",
      views: "5.1M",
      badge: "2 April",
    ),
    MovieModel(
      image: AppImages.move_6,
      title: "Mega",
      subtitle: "New Day",
      views: "12.1M",
      badge: "5 June",
    ),
  ];

  final List<String> subscriptionRules = [
    "Subscription Function is only to improve the user experience of the App. It does not affect the normal use of the app.",
    "Bonus can only be used to watch dramas, valid for 5 days, and will be automatically expired and liquidated after expiration.",
    "Gold coins will be used first when watching dramas, if not enough, Bonus will be used automatically.",
    "Gold coins will be used first when watching dramas, if not enough, Bonus will be used automatically.",
  ];
}
