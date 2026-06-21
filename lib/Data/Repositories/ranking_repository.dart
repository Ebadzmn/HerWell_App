import 'package:get/get.dart';
import 'package:uremz100/core/network/api_endpoints.dart';
import 'package:uremz100/core/network/network_caller.dart';
import 'package:uremz100/Data/Models/ranking_response_model.dart';

class RankingRepository {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  Future<RankingResponse> getRankingContent({
    required String filter,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'tab': 'ranking',
      'filter': filter,
    };

    final response = await _networkCaller.getRequest<dynamic>(
      ApiEndpoints.homeContent,
      queryParameters: queryParameters,
    );

    if (response.isSuccess && response.data != null) {
      try {
        return RankingResponse.fromJson(response.data);
      } catch (e) {
        return RankingResponse(
          success: false,
          statusCode: response.statusCode,
          message: 'Failed to parse ranking content: $e',
          data: null,
        );
      }
    }

    return RankingResponse(
      success: false,
      statusCode: response.statusCode,
      message: response.message,
      data: null,
    );
  }
}
