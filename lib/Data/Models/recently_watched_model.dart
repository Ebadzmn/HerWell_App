class RecentlyWatchedResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<RecentlyWatchedData> data;

  RecentlyWatchedResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RecentlyWatchedResponse.fromJson(Map<String, dynamic> json) {
    return RecentlyWatchedResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<RecentlyWatchedData>.from(
              json['data'].map((x) => RecentlyWatchedData.fromJson(x)))
          : [],
    );
  }
}

class RecentlyWatchedData {
  final RecentlyWatchedContentId contentId;
  final double completionPercentage;
  final int watchedSeconds;
  final String lastWatchedAt;

  RecentlyWatchedData({
    required this.contentId,
    required this.completionPercentage,
    required this.watchedSeconds,
    required this.lastWatchedAt,
  });

  factory RecentlyWatchedData.fromJson(Map<String, dynamic> json) {
    return RecentlyWatchedData(
      contentId: RecentlyWatchedContentId.fromJson(json['contentId'] ?? {}),
      completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
      watchedSeconds: json['watchedSeconds'] ?? 0,
      lastWatchedAt: json['lastWatchedAt'] ?? '',
    );
  }
}

class RecentlyWatchedContentId {
  final String id;
  final String title;
  final String posterUrl;
  final String type;

  RecentlyWatchedContentId({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.type,
  });

  factory RecentlyWatchedContentId.fromJson(Map<String, dynamic> json) {
    return RecentlyWatchedContentId(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
