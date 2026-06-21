// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:moeb_26/Core/routs.dart';
// import 'package:moeb_26/Services/storege_service.dart';
// import '../Config/api_constants.dart';
// import '../Config/storage_constants.dart';
// import '../Controller/internet_controller.dart';
// import '../widgets/Custom_snacbar.dart' as Helpers;
//
// class ApiClient extends GetxService {
//   static late Dio dio;
//   static String bearerToken = "";
//   static String? temporaryToken;
//
//   static const String noInternetMessage =
//       "Sorry! Something went wrong, please try again";
//   static const int timeoutInSeconds = 30;
//   static DateTime? _lastErrorTime;
//
//   // Future<void> fakeLogout() async {
//   //   try {
//   //     // Clear tokens from StorageService
//   //     await StorageService.setString(StorageConstants.bearerToken, "");
//   //     await StorageService.setString(StorageConstants.refreshToken, "");
//
//   //     // Optional: Clear other user-related data if needed
//   //     // await PrefsHelper.clearAll();
//
//   //     // Show success message
//
//   //     // Navigate to login screen
//   //   } catch (e) {
//   //     showCustomSnackBar(" failed: $e", isError: true);
//   //   }
//   // }
//
//   // void handleTokenExpired() {
//   //   fakeLogout();
//
//   //   showCustomSnackBar("Session expired. Please login again.", isError: true);
//
//   //   Get.offAllNamed(AppRoutes.LOGIN);
//   // }
//
//   @override
//   void onInit() {
//     super.onInit();
//     dio = Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.baseUrl,
//         connectTimeout: const Duration(seconds: timeoutInSeconds),
//         receiveTimeout: const Duration(seconds: timeoutInSeconds),
//         headers: {'Content-Type': 'application/json'},
//       ),
//     );
//
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           String? tokenToUse;
//
//           if (temporaryToken != null && temporaryToken!.isNotEmpty) {
//             tokenToUse = temporaryToken;
//           } else {
//             tokenToUse = await StorageService.getString(
//               StorageConstants.bearerToken,
//             );
//           }
//
//           if (tokenToUse != null && tokenToUse.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $tokenToUse';
//           }
//           debugPrint("➡️ ====> API REQUEST==========================");
//           debugPrint("➡️ ====> API Request: ${options.method} ${options.uri}");
//           debugPrint("➡️ ====> API Headers: ${options.headers}");
//           debugPrint(
//             "➡️ ====> API Query Parameters: ${options.queryParameters}",
//           );
//           debugPrint("➡️ ====> API Data: ${options.data}");
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           debugPrint("✅ ====> API RESPONSE==========================");
//           debugPrint("✅ ====> API Response: [${response.statusCode}]");
//           debugPrint("✅ ====> API URI: ${response.requestOptions.uri}");
//           debugPrint("✅ ====> API Data: ${response.data}");
//
//           return handler.next(response);
//         },
//
//         onError: (DioException e, handler) async {
//           final internet = Get.find<InternetController>();
//
//           // 1️⃣ Connection Error
//           if (e.type == DioExceptionType.connectionError) {
//             // Check if we actually have internet access
//             bool hasInternet = await InternetConnection().hasInternetAccess;
//
//             if (hasInternet) {
//               // Internet is available, but connection failed -> Server likely down
//               if (_lastErrorTime == null ||
//                   DateTime.now().difference(_lastErrorTime!) >
//                       const Duration(seconds: 3)) {
//                 _lastErrorTime = DateTime.now();
//                 Helpers.showCustomSnackBar(
//                   'Unable to connect to server. Please try again later.',
//                   isError: true,
//                 );
//               }
//             } else {
//               // Genuine No Internet
//               if (!internet.isShowingNoInternet.value) {
//                 internet.setOffline();
//                 Get.offAllNamed(Routes.noInternetScreen);
//               }
//             }
//             return handler.next(e);
//           }
//
//           // 2️⃣ Token expired → try refresh FIRST
//           if (e.response?.statusCode == 401 &&
//               !e.requestOptions.path.contains(ApiConstants.refreshToken) &&
//               !e.requestOptions.path.contains(ApiConstants.resetPassword) &&
//               !e.requestOptions.path.contains(ApiConstants.login) &&
//               !e.requestOptions.path.contains(ApiConstants.signup) &&
//               !e.requestOptions.path.contains(ApiConstants.verifyEmail)) {
//             final refreshed = await refreshToken();
//
//             if (refreshed) {
//               final newToken = await StorageService.getString(
//                 StorageConstants.bearerToken,
//               );
//
//               e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
//
//               final response = await dio.fetch(e.requestOptions);
//               return handler.resolve(response);
//             } else {
//               logoutUser();
//               return handler.reject(e);
//             }
//           }
//
//           // 3️⃣ Timeout
//           if (e.type == DioExceptionType.connectionTimeout ||
//               e.type == DioExceptionType.receiveTimeout) {
//             if (_lastErrorTime == null ||
//                 DateTime.now().difference(_lastErrorTime!) >
//                     const Duration(seconds: 3)) {
//               _lastErrorTime = DateTime.now();
//               Helpers.showCustomSnackBar(
//                 'Request timeout. Please try again.',
//                 isError: true,
//               );
//             }
//           }
//           // // 4️⃣ Server error
//
//           // else if (e.type == DioExceptionType.badResponse) {
//           //   if (_lastErrorTime == null ||
//           //       DateTime.now().difference(_lastErrorTime!) >
//           //           const Duration(seconds: 3)) {
//           //     _lastErrorTime = DateTime.now();
//           //     Helpers.showCustomSnackBar(
//           //       'Server error (${e.response?.statusCode})',
//           //       isError: true,
//           //     );
//           //   }
//           // }
//           // 5️⃣ Unknown error
//           // else {
//           //   if (_lastErrorTime == null ||
//           //       DateTime.now().difference(_lastErrorTime!) >
//           //           const Duration(seconds: 3)) {
//           //     _lastErrorTime = DateTime.now();
//           //     Helpers.showCustomSnackBar('Something went wrong', isError: true);
//           //   }
//           // }
//           debugPrint("❌ ====> API ERROR:==========================");
//           debugPrint("❌ ====> API MESSAGE: ${e.message}");
//           debugPrint('❌ ====> API URL: ${e.requestOptions.uri}');
//           debugPrint("❌ ====> API DATA: ${e.response?.data}");
//           debugPrint("❌ ====> API STATUS CODE: ${e.response?.statusCode}");
//           debugPrint(
//             "❌ ====> API STATUS MESSAGE: ${e.response?.statusMessage}",
//           );
//
//           return handler.next(e);
//         },
//       ),
//     );
//   }
//
//   /// GET
//   Future<Response> getData(
//     String uri, {
//     Map<String, dynamic>? query,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       return await dio.get(
//         uri,
//         queryParameters: query,
//         cancelToken: cancelToken,
//       );
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   /// POST
//   Future<Response> postData(
//     String uri,
//     dynamic body, {
//     CancelToken? cancelToken,
//     String? resetToken,
//   }) async {
//     // 👇 try-catch সরাও, rethrow হবে
//     return await dio.post(
//       uri,
//       data: body,
//       cancelToken: cancelToken,
//       options: resetToken != null
//           ? Options(
//               headers: {
//                 'Content-Type': 'application/json',
//                 'Authorization': 'Bearer $resetToken',
//               },
//             )
//           : null,
//     );
//   }
//
//   /// PUT
//   Future<Response> putData(
//     String uri,
//     dynamic body, {
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       return await dio.put(uri, data: body, cancelToken: cancelToken);
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   /// PATCH (missing before)
//   Future<Response> patchData(
//     String uri,
//     dynamic body, {
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       // If the body is FormData, ensure the correct content type is used.
//       Options? options;
//       if (body is FormData) {
//         options = Options(contentType: 'multipart/form-data');
//       }
//       return await dio.patch(
//         uri,
//         data: body,
//         options: options,
//         cancelToken: cancelToken,
//       );
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   /// DELETE
//   Future<Response> deleteData(
//     String uri, {
//     dynamic body,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       return await dio.delete(uri, data: body, cancelToken: cancelToken);
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   /// Multipart POST with progress
//   Future<Response> postMultipartData(
//     String uri,
//     Map<String, dynamic> body, {
//     required List<MultipartBody> multipartBody,
//     Function(int, int)? onSendProgress,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap(body);
//       for (MultipartBody element in multipartBody) {
//         formData.files.add(
//           MapEntry(
//             element.key,
//             await MultipartFile.fromFile(element.file.path),
//           ),
//         );
//       }
//       return await dio.post(
//         uri,
//         data: formData,
//         onSendProgress: onSendProgress,
//         cancelToken: cancelToken,
//       );
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   /// Multipart PUT with progress
//   Future<Response> patchMultipartData(
//     String uri,
//     Map<String, dynamic> body, {
//     required List<MultipartBody> multipartBody,
//     Function(int, int)? onSendProgress,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap(body);
//       for (MultipartBody element in multipartBody) {
//         formData.files.add(
//           MapEntry(
//             element.key,
//             await MultipartFile.fromFile(element.file.path),
//           ),
//         );
//       }
//       return await dio.patch(
//         uri,
//         data: formData,
//         onSendProgress: onSendProgress,
//         cancelToken: cancelToken,
//       );
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   /// File Download
//   Future<Response> downloadFile(
//     String url,
//     String savePath, {
//     Function(int, int)? onReceiveProgress,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       return await dio.download(
//         url,
//         savePath,
//         onReceiveProgress: onReceiveProgress,
//         cancelToken: cancelToken,
//       );
//     } on DioException catch (e) {
//       return _handleError(e);
//     }
//   }
//
//   /// Error handler
//   Response _handleError(DioException e) {
//     String message = noInternetMessage;
//     if (e.type == DioExceptionType.connectionTimeout) {
//       message = "Connection timed out";
//     } else if (e.type == DioExceptionType.receiveTimeout) {
//       message = "Server took too long to respond";
//     } else if (e.type == DioExceptionType.badResponse) {
//       message = "Bad response: ${e.response?.statusMessage ?? 'Unknown'}";
//     } else if (e.type == DioExceptionType.cancel) {
//       message = "Request cancelled";
//     } else if (e.type == DioExceptionType.unknown) {
//       message = "Unexpected error: ${e.message}";
//     }
//
//     return Response(
//       requestOptions: e.requestOptions,
//       statusCode: e.response?.statusCode ?? 0,
//       statusMessage: message,
//       data: e.response?.data,
//     );
//   }
//
//   /// token Expired
//
//   Future<bool> refreshToken() async {
//     try {
//       final refreshToken = await StorageService.getString(
//         StorageConstants.refreshToken,
//       );
//
//       final response = await postData(ApiConstants.refreshToken, {
//         'refreshToken': refreshToken,
//       });
//
//       if (response.statusCode == 200) {
//         final data = response.data['data'];
//         await StorageService.setString(
//           StorageConstants.bearerToken,
//           data['accessToken'],
//         );
//         await StorageService.setString(
//           StorageConstants.refreshToken,
//           data['refreshToken'],
//         );
//         return true;
//       }
//     } catch (_) {}
//     return false;
//   }
//
//   void logoutUser() {
//     StorageService.clearAll();
//     Get.offAllNamed(Routes.signscreen);
//   }
// }
//
// /// Multipart Body
// class MultipartBody {
//   String key;
//   File file;
//
//   MultipartBody(this.key, this.file);
// }
