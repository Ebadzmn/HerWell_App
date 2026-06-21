import 'package:uremz100/Data/Datasources/Remote/shorts_remote_datasource.dart';
import 'package:uremz100/Data/Models/shorts_response_model.dart';
import 'package:uremz100/core/network/api_response.dart';

class ShortsRepository {
  final ShortsRemoteDataSource _remoteDataSource;

  ShortsRepository(this._remoteDataSource);

  Future<ShortsResponse> getShorts({int limit = 5, String? cursor}) async {
    try {
      final ApiResponse<dynamic> response =
          await _remoteDataSource.getShorts(limit: limit, cursor: cursor);
      if (response.data != null) {
        return ShortsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to parse shorts response');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> trackView(String shortId) async {
    try {
      final response = await _remoteDataSource.trackView(shortId);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addToCollection(String itemId) async {
    try {
      final response = await _remoteDataSource.addToCollection(itemId);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
