class CastModel {
  final String name;
  final String seriesCount;
  final String imageUrl;

  CastModel({
    required this.name,
    required this.seriesCount,
    required this.imageUrl,
  });
}

class RelatedContentModel {
  final String title;
  final String category;
  final String views;
  final String imageUrl;
  final bool isNew;

  RelatedContentModel({
    required this.title,
    required this.category,
    required this.views,
    required this.imageUrl,
    this.isNew = false,
  });
}

class MovieDetailsModel {
  final String title;
  final String description;
  final int duration;
  final double rating;
  final int views;
  final int releaseYear;
  final String type;
  final int totalEpisodes;
  final int totalWatchTime;
  final List<String> cast;
  final String posterUrl;
  final String trailerUrl;
  final String videoUrl;

  MovieDetailsModel({
    required this.title,
    required this.description,
    required this.duration,
    required this.rating,
    required this.views,
    required this.releaseYear,
    required this.type,
    required this.totalEpisodes,
    required this.totalWatchTime,
    required this.cast,
    required this.posterUrl,
    required this.trailerUrl,
    required this.videoUrl,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      views: json['views'] ?? 0,
      releaseYear: json['releaseYear'] ?? 0,
      type: json['type'] ?? 'MOVIE',
      totalEpisodes: json['totalEpisodes'] ?? 0,
      totalWatchTime: json['totalWatchTime'] ?? 0,
      cast: (json['cast'] as List?)?.map((e) => e.toString()).toList() ?? [],
      posterUrl: json['posterUrl'] ?? '',
      trailerUrl: json['trailerUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}
