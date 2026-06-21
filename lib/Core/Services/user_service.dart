// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide Response;
// import 'package:moeb_26/Config/storage_constants.dart';
// import 'package:moeb_26/Services/storege_service.dart';
// import 'package:moeb_26/Services/user_profile_service.dart';
// import '../Ripositoryes/user_repository.dart';
//
// class UserService extends GetxService {
//   late UserRepo _userRepo;
//   final RxString _userId = "".obs;
//
//   String get userId => _userId.value;
//   set userId(String value) => _userId.value = value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _userRepo = UserRepo(apiClient: Get.find());
//     // Only fetch if token exists to avoid unauthorized API calls
//     checkTokenAndFetch();
//   }
//
//   /// Check for token before fetching user data
//   Future<void> checkTokenAndFetch() async {
//     final token = await StorageService.getString(StorageConstants.bearerToken);
//     if (token.isNotEmpty) {
//       await fetchUserId();
//     } else {
//       debugPrint("ℹ️ UserService: No token found, skipping profile API call.");
//     }
//   }
//
//   /// Fetch user profile and store the ID if not already set
//   Future<void> fetchUserId() async {
//     try {
//       // 1. Try to get from storage first (fastest)
//       final String userData = await StorageService.getString(
//         StorageConstants.userData,
//       );
//       if (userData.isNotEmpty) {
//         final Map<String, dynamic> user = json.decode(userData);
//         final id = user['_id'] ?? user['id'];
//         if (id != null) {
//           _userId.value = id.toString();
//           debugPrint("✅ UserService: Set userId from Storage: $id");
//           // Continue to fetch from API anyway to keep it fresh
//         }
//       }
//
//       // Check token again before API call just to be safe
//       final token = await StorageService.getString(StorageConstants.bearerToken);
//       if (token.isEmpty) return;
//
//       // 2. Fetch from API
//       final profileService = Get.find<UserProfileService>();
//       final response = await profileService.getUserProfile();
//       if (response.statusCode == 200) {
//         final id =
//             response.data['data']['_id']?.toString() ??
//                 response.data['data']['id']?.toString();
//         if (id != null) {
//           _userId.value = id;
//           debugPrint("✅ UserService: Set userId from profile API: $id");
//         }
//       }
//     } catch (e) {
//       debugPrint("❌ UserService: Error fetching userId: $e");
//     }
//   }
//
//   Future<UserService> init() async {
//     return this;
//   }
//
//   // ========== Vehicle only ==========
//   Future<Response> updateVehicles({
//     required List<Map<String, dynamic>> vehicles,
//   }) async {
//     try {
//       return await _userRepo.updateVehicles(vehicles: vehicles);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // ========== Documents only ==========
//   Future<Response> updateDocuments({
//     required List<Map<String, dynamic>> vehicles, // 👈 যোগ করা হয়েছে
//     required File drivingLicense,
//     required String drivingLicenseExpire,
//     required File hackLicense,
//     required String hackLicenseExpire,
//     File? localPermit,
//     String? localPermitExpire,
//     required File commercialInsurance,
//     required String commercialInsuranceExpire,
//     required File vehicleRegistration,
//     required String vehicleRegistrationExpire,
//     required File headshot,
//     required File frontView,
//     required File rearView,
//     required File interiorView,
//   }) async {
//     try {
//       return await _userRepo.updateDocuments(
//         vehicles: vehicles, // 👈 pass করো
//         drivingLicense: drivingLicense,
//         drivingLicenseExpire: drivingLicenseExpire,
//         hackLicense: hackLicense,
//         hackLicenseExpire: hackLicenseExpire,
//         localPermit: localPermit,
//         localPermitExpire: localPermitExpire,
//         commercialInsurance: commercialInsurance,
//         commercialInsuranceExpire: commercialInsuranceExpire,
//         vehicleRegistration: vehicleRegistration,
//         vehicleRegistrationExpire: vehicleRegistrationExpire,
//         headshot: headshot,
//         frontView: frontView,
//         rearView: rearView,
//         interiorView: interiorView,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
// }