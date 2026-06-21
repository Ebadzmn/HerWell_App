class RankingResponse {
  final bool success;
  final int statusCode;
  final String message;
  final RankingData? data;

  RankingResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory RankingResponse.fromJson(Map<String, dynamic> json) {
    return RankingResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null ? RankingData.fromJson(json['data']) : null,
    );
  }
}

class RankingData {
  final List<RankingSection> sections;

  RankingData({required this.sections});

  factory RankingData.fromJson(Map<String, dynamic> json) {
    return RankingData(
      sections: json['sections'] != null
          ? (json['sections'] as List)
              .map((i) => RankingSection.fromJson(i))
              .toList()
          : [],
    );
  }
}

class RankingSection {
  final String title;
  final String type;
  final String id;
  final List<RankingItem> items;

  RankingSection({
    required this.title,
    required this.type,
    required this.id,
    required this.items,
  });

  factory RankingSection.fromJson(Map<String, dynamic> json) {
    return RankingSection(
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      id: json['id'] ?? '',
      items: json['items'] != null
          ? (json['items'] as List)
              .map((i) => RankingItem.fromJson(i))
              .toList()
          : [],
    );
  }
}

class RankingItem {
  final dynamic id;
  final String title;
  final String posterUrl;
  final String type;
  final dynamic rating;
  final bool isRecent;
  final String? publishedAt;
  final String? createdAt;

  RankingItem({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.type,
    required this.rating,
    required this.isRecent,
    this.publishedAt,
    this.createdAt,
  });

  factory RankingItem.fromJson(Map<String, dynamic> json) {
    return RankingItem(
      id: json['id'],
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      type: json['type'] ?? '',
      rating: json['rating'],
      isRecent: json['isRecent'] ?? false,
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'],
    );
  }
}
