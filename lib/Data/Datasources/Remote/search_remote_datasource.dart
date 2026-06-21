import 'package:get/get.dart';
import 'package:uremz100/core/network/api_endpoints.dart';
import 'package:uremz100/core/network/api_response.dart';
import 'package:uremz100/core/network/network_caller.dart';

class SearchRemoteDataSource {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  Future<ApiResponse<dynamic>> searchContents({
    required String searchTerm,
  }) async {
    return await _networkCaller.getRequest(
      ApiEndpoints.searchContent,
      queryParameters: {
        'searchTerm': searchTerm,
      },
    );
  }
}
