// import 'package:dio/dio.dart';
// import '../services/storage_service.dart';
//
// class ApiInterceptor extends Interceptor {
//
//   // ── REQUEST আসার আগে ─────────────────────────────────────
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//
//     // প্রত্যেক Request এ Token যোগ করা
//     final token = StorageService.getToken();
//     if (token.isNotEmpty) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//
//     // Debug এর জন্য লগ
//     print('🌐 API REQUEST → ${options.method} ${options.uri}');
//
//     super.onRequest(options, handler);
//   }
//
//   // ── RESPONSE আসার পরে ─────────────────────────────────────
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     print('✅ API SUCCESS → ${response.statusCode} ${response.requestOptions.uri}');
//     super.onResponse(response, handler);
//   }
//
//   // ── ERROR হলে ─────────────────────────────────────────────
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     print('❌ API ERROR → ${err.message}');
//
//     if (err.response?.statusCode == 401) {
//       print('⚠️ Token Expired! User should logout.');
//       // এখানে Auto Logout এর লজিক দিতে পারো
//     }
//
//     super.onError(err, handler);
//   }
// }