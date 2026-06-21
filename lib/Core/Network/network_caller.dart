import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../services/storage_service.dart';
import 'api_endpoints.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'logger_interceptor.dart';

class NetworkCaller {
  late final Dio _dio;
  final StorageService _storageService = Get.find<StorageService>();

  NetworkCaller() {
    final BaseOptions options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(
        milliseconds: AppConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add Auth & Guest Token Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _storageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          final prefs = await SharedPreferences.getInstance();
          final guestId = prefs.getString('guest_id');
          if (guestId != null && guestId.isNotEmpty) {
            options.headers['x-guest-id'] = guestId;
          }

          return handler.next(options);
        },
      ),
    );

    // Add Logger Interceptor
    _dio.interceptors.add(LoggerInterceptor());
  }

  /// Generic GET request
  Future<ApiResponse<T>> getRequest<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> postRequest<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Generic PUT request
  Future<ApiResponse<T>> putRequest<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Generic PATCH request
  Future<ApiResponse<T>> patchRequest<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Generic DELETE request
  Future<ApiResponse<T>> deleteRequest<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Handle Dio Response
  ApiResponse<T> _handleResponse<T>(Response response) {
    final statusCode = response.statusCode ?? 500;

    // You might need to adjust this parsing depending on your API's exact response structure
    // e.g., if API returns { success: true, message: "...", data: {...} }

    final responseData = response.data;
    String message = 'Success';
    bool isSuccess = statusCode >= 200 && statusCode < 300;

    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('message')) {
      message = responseData['message'].toString();
    }

    if (isSuccess) {
      return ApiResponse.success(
        data: responseData as T,
        statusCode: statusCode,
        message: message,
      );
    } else {
      return ApiResponse.error(message: message, statusCode: statusCode);
    }
  }

  /// Handle Dio Exceptions
  Exception _handleException(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return InternetException('Connection timeout');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;
          String errorMessage = 'Server error';

          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('message')) {
            errorMessage = responseData['message'].toString();
          }

          if (statusCode == 401) {
            // Check if it's token expiry (depends on backend message/code, using generic logic here)
            if (errorMessage.toLowerCase().contains('expired')) {
              return TokenExpiredException(errorMessage, statusCode ?? 401);
            }
            return UnauthorizedException(errorMessage, statusCode ?? 401);
          } else if (statusCode != null && statusCode >= 500) {
            return ServerException(errorMessage, statusCode);
          }
          return ApiException(errorMessage, statusCode: statusCode);
        case DioExceptionType.connectionError:
          return InternetException('No Internet connection');
        case DioExceptionType.cancel:
          return ApiException('Request cancelled');
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return InternetException('No Internet connection');
          }
          return ApiException('Unexpected error occurred');
        default:
          return ApiException('Something went wrong');
      }
    }
    return ApiException(error.toString());
  }
}
