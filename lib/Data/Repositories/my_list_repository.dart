import 'package:uremz100/Data/Datasources/Remote/my_list_remote_datasource.dart';
import 'package:uremz100/Data/Models/recently_watched_model.dart';
import 'package:uremz100/Data/Models/my_collection_model.dart';
import 'package:uremz100/Data/Models/bulk_remove_collection_response_model.dart';
import 'package:uremz100/core/network/api_response.dart';

class MyListRepository {
  final MyListRemoteDataSource _remoteDataSource;

  MyListRepository(this._remoteDataSource);

  Future<RecentlyWatchedResponse> getRecentlyWatched() async {
    try {
      final ApiResponse<dynamic> response =
          await _remoteDataSource.getRecentlyWatched();
      if (response.data != null) {
        return RecentlyWatchedResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to parse recently watched response');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<MyCollectionResponse> getMyCollection({
    required int page,
    int limit = 10,
  }) async {
    try {
      final ApiResponse<dynamic> response = await _remoteDataSource
          .getMyCollection(page: page, limit: limit);
      if (response.data != null) {
        return MyCollectionResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to parse my collection response');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BulkRemoveCollectionResponse> removeBulkCollection(List<String> itemIds) async {
    try {
      final ApiResponse<dynamic> response = await _remoteDataSource.removeBulkCollection(itemIds);
      // Even if response.data is null, we can try to parse it because the model handles null data
      final dataToParse = response.data ?? <String, dynamic>{};
      
      // Merge with response meta so we get the success/message from the api response wrapper if they exist
      final mapToParse = (dataToParse is Map<String, dynamic>) ? dataToParse : <String, dynamic>{};
      
      // Inject standard ApiResponse fields into the map to parse
      mapToParse['success'] ??= response.isSuccess;
      mapToParse['message'] ??= response.message;
      mapToParse['statusCode'] ??= response.statusCode;

      return BulkRemoveCollectionResponse.fromJson(mapToParse);
    } catch (e) {
      rethrow;
    }
  }
}
