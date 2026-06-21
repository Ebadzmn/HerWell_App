import 'package:get/get.dart';
import 'package:uremz100/Utils/app_icons.dart';
import 'package:uremz100/Utils/app_images.dart';
import '../../Model/standart_vip_model.dart';

class BasicVipController extends GetxController {
  final List<VipPlanModel> basicPlans = [
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
}
