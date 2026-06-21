import 'package:get/get.dart';
import '../../core/network/network_caller.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/api_response.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  /// ===================== SIGNUP =====================
  Future<ApiResponse<dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.register,
      data: {
        "name": name,
        "email": email,
        "password": password,
      },
    );
  }

  /// ===================== OTP VERIFY =====================
  Future<ApiResponse<dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.verifyOtp,
      data: {
        "email": email,
        "otp": otp,
      },
    );
  }

  /// ===================== LOGIN =====================
  Future<ApiResponse<dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.login,
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  /// ===================== FORGOT PASSWORD =====================
  Future<ApiResponse<dynamic>> forgotPassword({
    required String email,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.forgotPassword,
      data: {
        "email": email,
      },
    );
  }

  /// ===================== RESET PASSWORD =====================
  Future<ApiResponse<dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.resetPassword,
      data: {
        "newPassword": newPassword,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $resetToken',
        },
      ),
    );
  }

  /// ===================== CHANGE PASSWORD =====================
  Future<ApiResponse<dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.changePassword,
      data: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      },
    );
  }

  /// ===================== RESTORE ACCOUNT =====================
  Future<ApiResponse<dynamic>> restoreAccount({
    required String email,
    required String password,
  }) async {
    return await _networkCaller.postRequest(
      ApiEndpoints.restoreAccount,
      data: {
        "email": email,
        "password": password,
      },
    );
  }
}
