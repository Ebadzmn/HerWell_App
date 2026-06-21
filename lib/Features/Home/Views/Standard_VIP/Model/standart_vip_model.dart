class VipFeatureModel {
  final String label;
  final String iconPath;

  VipFeatureModel({required this.label, required this.iconPath});
}

class VipPlanModel {
  final String title;
  final String price;
  final String? badge;
  final List<VipFeatureModel> features;

  VipPlanModel({
    required this.title,
    required this.price,
    this.badge,
    required this.features,
  });
}

class MovieModel {
  final String image;
  final String title;
  final String subtitle;
  final String views;
  final String? badge;

  MovieModel({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.views,
    this.badge,
  });
}
