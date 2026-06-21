import 'package:get/get.dart';
import 'package:uremz100/core/network/api_endpoints.dart';
import 'package:uremz100/core/network/api_response.dart';
import 'package:uremz100/core/network/network_caller.dart';

class ShortsRemoteDataSource {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  Future<ApiResponse<dynamic>> getShorts({
    int limit = 5,
    String? cursor,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
    };
    if (cursor != null && cursor.isNotEmpty) {
      queryParams['cursor'] = cursor;
    }

    return await _networkCaller.getRequest(
      ApiEndpoints.shorts,
      queryParameters: queryParams,
    );
  }

  Future<ApiResponse<dynamic>> trackView(String shortId) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.trackShortView(shortId),
    );
  }

  Future<ApiResponse<dynamic>> addToCollection(String itemId) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.myCollection,
      data: {'itemId': itemId},
    );
  }
}
