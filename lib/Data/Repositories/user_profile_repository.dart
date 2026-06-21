import 'package:get/get.dart';
import 'package:uremz100/core/network/api_response.dart';
import 'package:uremz100/Data/Datasources/Remote/user_remote_datasource.dart';

class UserProfileRepo {
  final UserRemoteDataSource _remoteDataSource = Get.find<UserRemoteDataSource>();

  Future<ApiResponse<dynamic>> getUserProfile() async {
    return await _remoteDataSource.getUserProfile();
  }

  Future<ApiResponse<dynamic>> deleteAccount({required String password}) async {
    return await _remoteDataSource.deleteAccount(password);
  }

  Future<ApiResponse<dynamic>> updateProfile({
    required String name,
    required String gender,
    required String dateOfBirth,
  }) async {
    return await _remoteDataSource.updateProfile(
      name: name,
      gender: gender,
      dateOfBirth: dateOfBirth,
    );
  }

  Future<ApiResponse<dynamic>> requestEmailChange({
    required String newEmail,
    required String password,
  }) async {
    return await _remoteDataSource.requestEmailChange(
      newEmail: newEmail,
      password: password,
    );
  }

  Future<ApiResponse<dynamic>> confirmEmailChange({
    required String otp,
  }) async {
    return await _remoteDataSource.confirmEmailChange(otp: otp);
  }

  Future<ApiResponse<dynamic>> getLegalPages() async {
    return await _remoteDataSource.getLegalPages();
  }

  Future<ApiResponse<dynamic>> getLegalPageBySlug(String slug) async {
    return await _remoteDataSource.getLegalPageBySlug(slug);
  }
}