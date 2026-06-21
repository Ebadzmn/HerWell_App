class BulkRemoveCollectionRequest {
  final List<String> itemIds;

  BulkRemoveCollectionRequest({required this.itemIds});

  Map<String, dynamic> toJson() {
    return {
      'itemIds': itemIds,
    };
  }
}
