// // Core/Network/network_exception.dart
//
// class NetworkException implements Exception {
//   final String message;
//   final int? statusCode;
//
//   NetworkException(this.message, {this.statusCode});
//
//   @override
//   String toString() => message;
//
//   // Dio Error কে সুন্দর করে কনভার্ট করা
//   factory NetworkException.fromDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return NetworkException("Request timeout. Please check your internet.");
//
//       case DioExceptionType.noInternetConnection:
//         return NetworkException("No internet connection.");
//
//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         final msg = error.response?.data?['message'] ?? 'Server error occurred';
//         return NetworkException(msg, statusCode: statusCode);
//
//       case DioExceptionType.cancel:
//         return NetworkException("Request was cancelled.");
//
//       default:
//         return NetworkException("Something went wrong. Please try again.");
//     }
//   }
// }