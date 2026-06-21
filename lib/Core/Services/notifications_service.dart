// import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide Response;
// import '../Ripositoryes/notifications_repository.dart';
// import 'api_client.dart';
//
// class NotificationsService extends GetxService {
//   late NotificationsRepo _notificationsRepo;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _notificationsRepo = NotificationsRepo(apiClient: Get.find<ApiClient>());
//   }
//
//   Future<Response> getMyNotifications() async {
//     try {
//       return await _notificationsRepo.getMyNotifications();
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<Response> markAllAsRead() async {
//     try {
//       return await _notificationsRepo.markAllAsRead();
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<Response> markAsRead(String notificationId) async {
//     try {
//       return await _notificationsRepo.markAsRead(notificationId);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }