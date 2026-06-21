import 'package:uremz100/Domain/Entities/search_content_entity.dart';

class SearchResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final SearchMetaModel? meta;
  final List<SearchContentModel>? data;

  SearchResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.meta,
    this.data,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      meta: json['meta'] != null ? SearchMetaModel.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<SearchContentModel>.from(
              json['data'].map((x) => SearchContentModel.fromJson(x)))
          : null,
    );
  }
}

class SearchMetaModel {
  final int total;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  SearchMetaModel({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory SearchMetaModel.fromJson(Map<String, dynamic> json) {
    return SearchMetaModel(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}

class SearchContentModel {
  final String id;
  final String title;
  final String posterUrl;
  final int releaseYear;
  final num rating;
  final String type;
  final bool isRecent;
  final DateTime? publishedAt;

  SearchContentModel({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.releaseYear,
    required this.rating,
    required this.type,
    required this.isRecent,
    this.publishedAt,
  });

  factory SearchContentModel.fromJson(Map<String, dynamic> json) {
    return SearchContentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      releaseYear: json['releaseYear'] ?? 0,
      rating: json['rating'] ?? 0,
      type: json['type'] ?? '',
      isRecent: json['isRecent'] ?? false,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
    );
  }

  SearchContentEntity toEntity() {
    return SearchContentEntity(
      id: id,
      title: title,
      posterUrl: posterUrl,
      releaseYear: releaseYear,
      rating: rating,
      type: type,
      isRecent: isRecent,
      publishedAt: publishedAt,
    );
  }
}
