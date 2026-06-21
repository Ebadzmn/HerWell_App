class MyCollectionResponse {
  final bool success;
  final int statusCode;
  final String message;
  final PaginationMeta? meta;
  final List<MyCollectionData> data;

  MyCollectionResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.meta,
    required this.data,
  });

  factory MyCollectionResponse.fromJson(Map<String, dynamic> json) {
    return MyCollectionResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<MyCollectionData>.from(
              json['data'].map((x) => MyCollectionData.fromJson(x)))
          : [],
    );
  }
}

class PaginationMeta {
  final int total;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  PaginationMeta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}

class MyCollectionData {
  final MyCollectionItemId itemId;
  final String createdAt;

  MyCollectionData({
    required this.itemId,
    required this.createdAt,
  });

  factory MyCollectionData.fromJson(Map<String, dynamic> json) {
    return MyCollectionData(
      itemId: MyCollectionItemId.fromJson(json['itemId'] ?? {}),
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class MyCollectionItemId {
  final String id;
  final String title;
  final String posterUrl;
  final String type;

  MyCollectionItemId({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.type,
  });

  factory MyCollectionItemId.fromJson(Map<String, dynamic> json) {
    return MyCollectionItemId(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
