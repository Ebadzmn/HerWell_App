// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
// import 'package:moeb_26/Config/app_constants.dart';
// import 'package:moeb_26/Services/socket_service.dart';
// import 'package:moeb_26/Services/storege_service.dart';
//
// import 'package:moeb_26/Services/user_service.dart';
//
// import '../Config/storage_constants.dart';
// import '../Core/routs.dart';
// import '../Ripositoryes/auth_reporitory.dart';
// import 'api_client.dart';
//
// class AuthService extends GetxService {
//   late AuthRepo _authRepo;
//
//   // Reactive state
//   final isLoggedIn = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Explicitly find ApiClient to ensure it's initialized before AuthRepo
//     _authRepo = AuthRepo(apiClient: Get.put(ApiClient()));
//
//     // Check initial login state
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final token = await StorageService.getString(StorageConstants.bearerToken);
//     final userData = await StorageService.getString(StorageConstants.userData);
//     if (userData.isNotEmpty) {
//       try {
//         final Map<String, dynamic> user = jsonDecode(userData);
//         final id = user['_id'] ?? user['id'];
//         if (id != null) {
//           Get.find<UserService>().userId = id.toString();
//           debugPrint("✅ Logged in user ID: $id");
//         }
//       } catch (_) {}
//     }
//     isLoggedIn.value = token.isNotEmpty;
//   }
//
//   Future<AuthService> init() async {
//     return this;
//   }
//
//   /// ===================== SIGNUP =====================
//   Future<Response> signup({
//     required String name,
//     required String email,
//     required String password,
//     required String phone,
//     required String home,
//     required String serviceArea,
//     required int experience,
//     required String company,
//     required String companyRole,
//     required List<Map<String, dynamic>> vehicles,
//     required File drivingLicenseFile,
//     required String drivingLicenseExpiry,
//     required File hackLicenseFile,
//     required String hackLicenseExpiry,
//     File? localPermitFile,
//     String? localPermitExpiry,
//     required File commercialInsuranceFile,
//     required String commercialInsuranceExpiry,
//     required File vehicleRegistrationFile,
//     required String vehicleRegistrationExpiry,
//     required File headshotFile,
//     required File vehiclePhotoFront,
//     required File vehiclePhotoRear,
//     required File vehiclePhotoInterior,
//   }) async {
//     try {
//       final response = await _authRepo.signup(
//         name: name,
//         email: email,
//         password: password,
//         phone: phone,
//         home: home,
//         serviceArea: serviceArea,
//         experience: experience,
//         company: company,
//         companyRole: companyRole,
//         vehicles: vehicles,
//         drivingLicenseFile: drivingLicenseFile,
//         drivingLicenseExpiry: drivingLicenseExpiry,
//         hackLicenseFile: hackLicenseFile,
//         hackLicenseExpiry: hackLicenseExpiry,
//         localPermitFile: localPermitFile,
//         localPermitExpiry: localPermitExpiry,
//         commercialInsuranceFile: commercialInsuranceFile,
//         commercialInsuranceExpiry: commercialInsuranceExpiry,
//         vehicleRegistrationFile: vehicleRegistrationFile,
//         vehicleRegistrationExpiry: vehicleRegistrationExpiry,
//         headshotFile: headshotFile,
//         vehiclePhotoFront: vehiclePhotoFront,
//         vehiclePhotoRear: vehiclePhotoRear,
//         vehiclePhotoInterior: vehiclePhotoInterior,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== LOGIN =====================
//   Future<Response> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       String? fcmToken;
//       try {
//         fcmToken = await FirebaseMessaging.instance.getToken();
//         debugPrint("FCM Token dynamically fetched for login: $fcmToken");
//       } catch (e) {
//         debugPrint("Error fetching FCM token: $e");
//       }
//
//       AppConstants.fcmToken = fcmToken ?? AppConstants.fcmToken;
//       await StorageService.setString(StorageConstants.fcmToken, AppConstants.fcmToken);
//
//       final response = await _authRepo.login(
//         email: email,
//         password: password,
//         deviceToken: AppConstants.fcmToken,
//       );
//
//       final data = response.data;
//       final authData = data['data'] ?? data;
//       bool isRestricted = authData['isRestricted'] == true;
//       bool isPending = authData['isPending'] == true;
//
//       await handleAuthResponse(response, isTemporary: isRestricted || isPending);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== LOGOUT =====================
//   Future<Response> logout() async {
//     try {
//       String? fcmToken;
//       try {
//         fcmToken = await FirebaseMessaging.instance.getToken();
//         debugPrint("FCM Token dynamically fetched for logout: $fcmToken");
//       } catch (e) {
//         debugPrint("Error fetching FCM token: $e");
//       }
//
//       final response = await _authRepo.logout(deviceToken: AppConstants.fcmToken);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         await _clearLocalAuth();
//         Get.offAllNamed(Routes.signscreen);
//       }
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== FORGOT PASSWORD =====================
//   Future<Response> forgotPassword(String email) async {
//     try {
//       final response = await _authRepo.forgotPassword(email: email);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== OTP VERIFY =====================
//   Future<Response> verifyOtp({
//     required String email,
//     required int otp, // 👈 controller থেকে আসছে
//   }) async {
//     try {
//       final response = await _authRepo.otpVerify(
//         email: email,
//         oneTimeCode: otp, // 👈 repo এ oneTimeCode
//       );
//       await handleAuthResponse(response);
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== RESEND OTP =====================
//   Future<void> resendOtp(String email) async {
//     try {
//       await _authRepo.resentOtp(email: email);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== RESET PASSWORD =====================
//   Future<Response> resetPassword({
//     required String resetToken,
//     required String newPassword,
//     required String confirmPassword,
//   }) async {
//     try {
//       final response = await _authRepo.resetPassword(
//         resetToken: resetToken, // 👈 যোগ করো
//         newPassword: newPassword,
//         confirmPassword: confirmPassword,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== CHANGE PASSWORD =====================
//   Future<Response> changePassword({
//     required String currentPassword,
//     required String newPassword,
//     required String confirmPassword,
//   }) async {
//     try {
//       final response = await _authRepo.changePassword(
//         currentPassword: currentPassword,
//         newPassword: newPassword,
//         confirmPassword: confirmPassword,
//       );
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== HELPER METHODS =====================
//
//   /// Handles successful auth response (Login/Signup/Verify)
//   Future<void> handleAuthResponse(Response response, {bool isTemporary = false}) async {
//     try {
//       final data = response.data;
//       if (data == null) return;
//
//       // Check if data is nested
//       final authData = data['data'] ?? data;
//
//       if (authData is Map<String, dynamic>) {
//         final String? accessToken =
//             authData['accessToken'] ?? authData['token'];
//         final String? refreshToken = authData['refreshToken'];
//
//         if (accessToken != null) {
//           if (isTemporary) {
//             ApiClient.temporaryToken = accessToken;
//             debugPrint("⚠️ Token saved temporarily (Restricted mode)");
//           } else {
//             ApiClient.temporaryToken = null; // Clear if previously restricted
//             await StorageService.setString(
//               StorageConstants.bearerToken,
//               accessToken,
//             );
//           }
//           isLoggedIn.value = true;
//           // Refresh socket with new token
//           try {
//             Get.find<SocketService>().initSocket();
//           } catch (_) {}
//         }
//
//         if (refreshToken != null && !isTemporary) {
//           await StorageService.setString(
//             StorageConstants.refreshToken,
//             refreshToken,
//           );
//         }
//
//         final user = authData['user'] ?? authData;
//         if (user is Map<String, dynamic>) {
//           final id = user['_id'] ?? user['id'];
//           if (id != null) {
//             if (!isTemporary) {
//               await StorageService.setString(
//                 StorageConstants.userData,
//                 jsonEncode(user),
//               );
//             }
//             final userService = Get.find<UserService>();
//             userService.userId = id.toString();
//             // Fetch latest profile data after successful login
//             if (!isTemporary) {
//               userService.fetchUserId();
//             }
//           }
//         }
//       }
//     } catch (e) {
//       print("Error parsing auth response: $e");
//     }
//   }
//
//   /// Clears all local auth data
//   Future<void> _clearLocalAuth() async {
//     await StorageService.remove(StorageConstants.bearerToken);
//     await StorageService.remove(StorageConstants.refreshToken);
//     await StorageService.remove(StorageConstants.userData);
//     ApiClient.temporaryToken = null;
//     isLoggedIn.value = false;
//   }
//
//   /// Check if user is authenticated
//   bool get isAuthenticated => isLoggedIn.value;
// }