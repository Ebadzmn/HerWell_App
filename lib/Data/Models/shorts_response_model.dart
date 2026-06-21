import '../../../Features/Home/Views/Shorts/Model/shorts_model.dart';

class ShortsResponse {
  final ShortsMeta? meta;
  final List<ShortsModel> data;

  ShortsResponse({
    this.meta,
    required this.data,
  });

  factory ShortsResponse.fromJson(Map<String, dynamic> json) {
    return ShortsResponse(
      meta: json['meta'] != null ? ShortsMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<ShortsModel>.from(
              json['data'].map((x) => ShortsModel.fromJson(x)))
          : [],
    );
  }
}

class ShortsMeta {
  final int limit;
  final String? nextCursor;
  final bool hasNextPage;

  ShortsMeta({
    required this.limit,
    this.nextCursor,
    required this.hasNextPage,
  });

  factory ShortsMeta.fromJson(Map<String, dynamic> json) {
    return ShortsMeta(
      limit: json['limit'] ?? 5,
      nextCursor: json['nextCursor'],
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
