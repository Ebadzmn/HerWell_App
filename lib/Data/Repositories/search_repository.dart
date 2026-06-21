import 'package:uremz100/Data/Datasources/Remote/search_remote_datasource.dart';
import 'package:uremz100/Data/Models/search_response_model.dart';
import 'package:uremz100/core/network/api_response.dart';

class SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepository(this._remoteDataSource);

  Future<ApiResponse<SearchResponseModel>> searchContents(String searchTerm) async {
    final response = await _remoteDataSource.searchContents(searchTerm: searchTerm);

    if (response.isSuccess && response.data != null) {
      try {
        final content = SearchResponseModel.fromJson(response.data);
        return ApiResponse.success(
          data: content,
          message: response.message,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse search content: $e',
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
