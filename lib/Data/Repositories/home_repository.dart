import 'package:uremz100/core/network/network_caller.dart';
import 'package:uremz100/core/network/api_endpoints.dart';
import 'package:uremz100/core/network/api_response.dart';
import 'package:uremz100/Data/Models/home_content_model.dart';
import 'package:get/get.dart';

class HomeRepository {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  Future<ApiResponse<HomeContentResponse>> getHomeContent(String tab, {String? filter}) async {
    final Map<String, dynamic> queryParameters = {'tab': tab};
    if (filter != null) {
      queryParameters['filter'] = filter;
    }

    final response = await _networkCaller.getRequest<dynamic>(
      ApiEndpoints.homeContent,
      queryParameters: queryParameters,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final content = HomeContentResponse.fromJson(response.data);
        return ApiResponse.success(
          data: content,
          message: response.message,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse home content: $e',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.message,
      statusCode: response.statusCode,
    );
  }
}
