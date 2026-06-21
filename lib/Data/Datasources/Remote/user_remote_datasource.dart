import 'package:get/get.dart';
import 'package:uremz100/core/network/api_endpoints.dart';
import 'package:uremz100/core/network/api_response.dart';
import 'package:uremz100/core/network/network_caller.dart';

class UserRemoteDataSource {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  Future<ApiResponse<dynamic>> getUserProfile() async {
    return await _networkCaller.getRequest(ApiEndpoints.userProfile);
  }

  Future<ApiResponse<dynamic>> deleteAccount(String password) async {
    return await _networkCaller.deleteRequest(
      ApiEndpoints.deleteAccount,
      data: {
        "password": password,
      },
    );
  }

  Future<ApiResponse<dynamic>> updateProfile({
    required String name,
    required String gender,
    required String dateOfBirth,
  }) async {
    return await _networkCaller.patchRequest(
      ApiEndpoints.userProfile,
      data: {
        "name": name,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
      },
    );
  }

  Future<ApiResponse<dynamic>> requestEmailChange({
    required String newEmail,
    required String password,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.requestEmailChange,
      data: {
        "newEmail": newEmail,
        "password": password,
      },
    );
  }

  Future<ApiResponse<dynamic>> confirmEmailChange({
    required String otp,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.confirmEmailChange,
      data: {
        "otp": otp,
      },
    );
  }

  Future<ApiResponse<dynamic>> getLegalPages() async {
    return await _networkCaller.getRequest(
      ApiEndpoints.legals,
    );
  }

  Future<ApiResponse<dynamic>> getLegalPageBySlug(String slug) async {
    return await _networkCaller.getRequest(
      ApiEndpoints.legalBySlug(slug),
    );
  }
}
