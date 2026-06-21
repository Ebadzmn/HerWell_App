class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
  }
}

class InternetException extends ApiException {
  InternetException([String message = 'No Internet connection']) : super(message);
}

class ServerException extends ApiException {
  ServerException([String message = 'Internal Server Error', int? statusCode]) : super(message, statusCode: statusCode);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized access', int statusCode = 401]) : super(message, statusCode: statusCode);
}

class TokenExpiredException extends ApiException {
  TokenExpiredException([String message = 'Token has expired', int statusCode = 401]) : super(message, statusCode: statusCode);
}
