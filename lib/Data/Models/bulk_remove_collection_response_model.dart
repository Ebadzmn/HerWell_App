class BulkRemoveCollectionResponse {
  final bool success;
  final int statusCode;
  final String message;
  final BulkRemoveCollectionData? data;

  BulkRemoveCollectionResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory BulkRemoveCollectionResponse.fromJson(Map<String, dynamic> json) {
    return BulkRemoveCollectionResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? BulkRemoveCollectionData.fromJson(json['data'])
          : null,
    );
  }
}

class BulkRemoveCollectionData {
  final int deletedCount;
  final List<String> itemIds;

  BulkRemoveCollectionData({
    required this.deletedCount,
    required this.itemIds,
  });

  factory BulkRemoveCollectionData.fromJson(Map<String, dynamic> json) {
    return BulkRemoveCollectionData(
      deletedCount: json['deletedCount'] ?? 0,
      itemIds: json['itemIds'] != null ? List<String>.from(json['itemIds']) : [],
    );
  }
}
