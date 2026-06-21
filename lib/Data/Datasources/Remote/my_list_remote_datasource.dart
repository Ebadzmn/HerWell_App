import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:uremz100/core/network/api_endpoints.dart';
import 'package:uremz100/core/network/api_response.dart';
import 'package:uremz100/core/network/network_caller.dart';

class MyListRemoteDataSource {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  Future<ApiResponse<dynamic>> getRecentlyWatched() async {
    return await _networkCaller.getRequest(ApiEndpoints.recentlyWatched);
  }

  Future<ApiResponse<dynamic>> getMyCollection({
    required int page,
    int limit = 10,
  }) async {
    return await _networkCaller.getRequest(
      ApiEndpoints.myCollection,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
  }

  Future<ApiResponse<dynamic>> removeBulkCollection(List<String> itemIds) async {
    return await _networkCaller.deleteRequest(
      ApiEndpoints.bulkRemoveCollection,
      data: {
        "itemIds": itemIds,
      },
    );
  }
}
