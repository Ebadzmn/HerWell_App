class EpisodeModel {
  final String id;
  final String description;
  final int duration;
  final int episodeNumber;
  final String planStatus;
  final String releaseDate;
  final String seasonId;
  final int seasonNumber;
  final String seriesId;
  final String status;
  final String thumbnailUrl;
  final String title;
  final String videoUrl;
  final int requiredCoin;

  EpisodeModel({
    required this.id,
    required this.description,
    required this.duration,
    required this.episodeNumber,
    required this.planStatus,
    required this.releaseDate,
    required this.seasonId,
    required this.seasonNumber,
    required this.seriesId,
    required this.status,
    required this.thumbnailUrl,
    required this.title,
    required this.videoUrl,
    this.requiredCoin = 0,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: json['duration'] is int ? json['duration'] : (int.tryParse(json['duration']?.toString() ?? '') ?? 0),
      episodeNumber: json['episodeNumber'] is int ? json['episodeNumber'] : (int.tryParse(json['episodeNumber']?.toString() ?? '') ?? 0),
      planStatus: json['planStatus']?.toString() ?? '',
      releaseDate: json['releaseDate']?.toString() ?? '',
      seasonId: json['seasonId']?.toString() ?? '',
      seasonNumber: json['seasonNumber'] is int ? json['seasonNumber'] : (int.tryParse(json['seasonNumber']?.toString() ?? '') ?? 0),
      seriesId: json['seriesId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      videoUrl: json['videoUrl']?.toString() ?? '',
      requiredCoin: json['requiredCoin'] is int ? json['requiredCoin'] : (int.tryParse(json['requiredCoin']?.toString() ?? '') ?? 0),
    );
  }
}

class SeasonModel {
  final String id;
  final int episodeCount;
  final String posterUrl;
  final int seasonNumber;
  final String seriesId;
  final String title;
  final String trailerUrl;

  SeasonModel({
    required this.id,
    required this.episodeCount,
    required this.posterUrl,
    required this.seasonNumber,
    required this.seriesId,
    required this.title,
    required this.trailerUrl,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id']?.toString() ?? '',
      episodeCount: json['episodeCount'] is int ? json['episodeCount'] : (int.tryParse(json['episodeCount']?.toString() ?? '') ?? 0),
      posterUrl: json['posterUrl']?.toString() ?? '',
      seasonNumber: json['seasonNumber'] is int ? json['seasonNumber'] : (int.tryParse(json['seasonNumber']?.toString() ?? '') ?? 0),
      seriesId: json['seriesId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      trailerUrl: json['trailerUrl']?.toString() ?? '',
    );
  }
}

class ContentDetailsModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final int duration;
  final int releaseYear;
  final double rating;
  final int views;
  final List<String> cast;
  final List<String> genres;
  final List<String> planStatus;
  final String type;
  final String status;
  
  final bool isPopularSeries;
  final bool isRecent;
  final String publishedAt;
  final String trailerUrl;
  final String videoUrl;
  final String createdAt;
  final String updatedAt;

  // Series specific fields
  final List<SeasonModel> seasons;
  final int seasonsCount;
  final int totalEpisodes;
  final int totalWatchTime;

  ContentDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.duration,
    required this.releaseYear,
    required this.rating,
    required this.views,
    required this.cast,
    required this.genres,
    required this.planStatus,
    required this.type,
    required this.status,
    required this.isPopularSeries,
    required this.isRecent,
    required this.publishedAt,
    required this.trailerUrl,
    required this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.seasons,
    required this.seasonsCount,
    required this.totalEpisodes,
    required this.totalWatchTime,
  });

  factory ContentDetailsModel.fromJson(Map<String, dynamic> json) {
    return ContentDetailsModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      posterUrl: json['posterUrl']?.toString() ?? '',
      duration: json['duration'] is int ? json['duration'] : (int.tryParse(json['duration']?.toString() ?? '') ?? 0),
      releaseYear: json['releaseYear'] is int ? json['releaseYear'] : (int.tryParse(json['releaseYear']?.toString() ?? '') ?? 0),
      rating: (json['rating'] is num ? (json['rating'] as num).toDouble() : (double.tryParse(json['rating']?.toString() ?? '') ?? 0.0)),
      views: json['views'] is int ? json['views'] : (int.tryParse(json['views']?.toString() ?? '') ?? 0),
      cast: json['cast'] != null ? List<String>.from(json['cast']) : [],
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
      planStatus: json['planStatus'] != null ? List<String>.from(json['planStatus']) : [],
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      
      isPopularSeries: json['isPopularSeries'] == true,
      isRecent: json['isRecent'] == true,
      publishedAt: json['publishedAt']?.toString() ?? '',
      trailerUrl: json['trailerUrl']?.toString() ?? '',
      videoUrl: json['videoUrl']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      
      seasons: json['seasons'] != null ? (json['seasons'] as List).map((v) => SeasonModel.fromJson(v)).toList() : [],
      seasonsCount: json['seasonsCount'] is int ? json['seasonsCount'] : (int.tryParse(json['seasonsCount']?.toString() ?? '') ?? 0),
      totalEpisodes: json['totalEpisodes'] is int ? json['totalEpisodes'] : (int.tryParse(json['totalEpisodes']?.toString() ?? '') ?? 0),
      totalWatchTime: json['totalWatchTime'] is int ? json['totalWatchTime'] : (int.tryParse(json['totalWatchTime']?.toString() ?? '') ?? 0),
    );
  }
}

class PlaybackUrlModel {
  final String url;
  final String expiresAt;

  PlaybackUrlModel({
    required this.url,
    required this.expiresAt,
  });

  factory PlaybackUrlModel.fromJson(Map<String, dynamic> json) {
    return PlaybackUrlModel(
      url: json['url']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString() ?? '',
    );
  }
}
