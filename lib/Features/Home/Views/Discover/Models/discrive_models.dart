class DiscoverMovie {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String? badge;
  final String views;
  final String description;
  final List<String> categories;
  final bool isVip;

  DiscoverMovie({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    this.badge,
    required this.views,
    this.description =
        "An intense journey where danger, courage, and survival collide in a high-stakes battle.",
    required this.categories,
    this.isVip = false,
  });
}

class BonusItem {
  final int coins;
  final String time;
  final bool isClaimed;

  BonusItem({required this.coins, required this.time, this.isClaimed = false});
}
