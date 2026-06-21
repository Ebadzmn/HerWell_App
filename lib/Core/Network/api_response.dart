class ApiResponse<T> {
  final bool isSuccess;
  final String message;
  final int statusCode;
  final T? data;

  ApiResponse({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    this.data,
  });

  /// Factory for a successful response
  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int statusCode = 200,
  }) {
    return ApiResponse(
      isSuccess: true,
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }

  /// Factory for an error response
  factory ApiResponse.error({
    required String message,
    required int statusCode,
  }) {
    return ApiResponse(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
