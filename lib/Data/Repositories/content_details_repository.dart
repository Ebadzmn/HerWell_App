import 'package:uremz100/core/network/network_caller.dart';
import 'package:uremz100/core/network/api_endpoints.dart';
import 'package:uremz100/core/network/api_response.dart';
import 'package:uremz100/Data/Models/content_details_model.dart';
import 'package:get/get.dart';

class ContentDetailsRepository {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  Future<ApiResponse<ContentDetailsModel>> getContentDetails(String contentId) async {
    final response = await _networkCaller.getRequest<dynamic>(
      ApiEndpoints.contentDetails(contentId),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final dataObj = response.data['data'] ?? response.data;
        final details = ContentDetailsModel.fromJson(dataObj);
        return ApiResponse.success(
          data: details,
          message: response.message,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse content details: $e',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<ApiResponse<PlaybackUrlModel>> getPlaybackUrl(String contentId) async {
    final response = await _networkCaller.getRequest<dynamic>(
      ApiEndpoints.playbackUrl(contentId),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final dataObj = response.data['data'] ?? response.data;
        final playback = PlaybackUrlModel.fromJson(dataObj);
        return ApiResponse.success(
          data: playback,
          message: response.message,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse playback URL: $e',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<ApiResponse<void>> trackProgress(String contentId, int watchedSeconds) async {
    final response = await _networkCaller.postRequest<dynamic>(
      ApiEndpoints.trackProgress,
      data: {
        'contentId': contentId,
        'watchedSeconds': watchedSeconds,
      },
    );

    if (response.isSuccess) {
      return ApiResponse.success(
        data: null,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<ApiResponse<Map<String, dynamic>?>> getWatchProgress(String contentId) async {
    final response = await _networkCaller.getRequest<dynamic>(
      ApiEndpoints.watchProgress(contentId),
    );

    if (response.isSuccess) {
      try {
        final data = response.data['data'];
        if (data == null) {
          return ApiResponse.success(
            data: null,
            message: response.message,
            statusCode: response.statusCode,
          );
        }
        return ApiResponse.success(
          data: Map<String, dynamic>.from(data),
          message: response.message,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse watch progress: $e',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<ApiResponse<void>> addToCollection(String itemId) async {
    final response = await _networkCaller.postRequest<dynamic>(
      ApiEndpoints.myCollection,
      data: {'itemId': itemId},
    );

    if (response.isSuccess) {
      return ApiResponse.success(
        data: null,
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse.error(
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<ApiResponse<List<EpisodeModel>>> getSeasonEpisodes(String seasonId) async {
    final response = await _networkCaller.getRequest<dynamic>(
      ApiEndpoints.seasonEpisodes(seasonId),
    );

    if (response.isSuccess && response.data != null) {
      try {
        final dataObj = response.data['data'] ?? response.data;
        final List<EpisodeModel> episodes = (dataObj as List).map((v) => EpisodeModel.fromJson(v)).toList();
        return ApiResponse.success(
          data: episodes,
          message: response.message,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse season episodes: $e',
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
