class SearchContentEntity {
  final String id;
  final String title;
  final String posterUrl;
  final int releaseYear;
  final num rating;
  final String type;
  final bool isRecent;
  final DateTime? publishedAt;

  SearchContentEntity({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.releaseYear,
    required this.rating,
    required this.type,
    required this.isRecent,
    this.publishedAt,
  });
}
