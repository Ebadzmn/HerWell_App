class MovieItem {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String? badge;
  final String views;

  MovieItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    this.badge,
    required this.views,
  });
}
