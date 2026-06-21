import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  static const String _divider = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$_divider');
      debugPrint('🚀 API REQUEST');
      debugPrint('$_divider');
      debugPrint('METHOD: ${options.method.toUpperCase()}');
      debugPrint('URL: ${options.uri}');
      
      debugPrint('\nHEADERS:');
      _printPrettyJson(options.headers);

      if (options.queryParameters.isNotEmpty) {
        debugPrint('\nQUERY PARAMS:');
        _printPrettyJson(options.queryParameters);
      }

      if (options.data != null) {
        debugPrint('\nREQUEST BODY:');
        if (options.data is FormData) {
          final formData = options.data as FormData;
          debugPrint('{');
          for (var field in formData.fields) {
            debugPrint('  "${field.key}": "${field.value}",');
          }
          for (var file in formData.files) {
            debugPrint('  "${file.key}": "File: ${file.value.filename}",');
          }
          debugPrint('}');
        } else {
          _printPrettyJson(options.data);
        }
      }
      debugPrint('$_divider\n');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$_divider');
      debugPrint('✅ API RESPONSE');
      debugPrint('$_divider');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('\nURL:');
      debugPrint('${response.requestOptions.uri}');
      
      debugPrint('\nRESPONSE:');
      _printPrettyJson(response.data);
      debugPrint('$_divider\n');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('\n$_divider');
      debugPrint('❌ API ERROR');
      debugPrint('$_divider');
      debugPrint('STATUS CODE: ${err.response?.statusCode ?? 'N/A'}');
      debugPrint('\nURL:');
      debugPrint('${err.requestOptions.uri}');
      
      debugPrint('\nERROR MESSAGE:');
      debugPrint('${err.message}');

      if (err.response?.data != null) {
        debugPrint('\nRESPONSE:');
        _printPrettyJson(err.response?.data);
      }
      debugPrint('$_divider\n');
    }
    super.onError(err, handler);
  }

  void _printPrettyJson(dynamic data) {
    try {
      if (data == null) {
        debugPrint('null');
        return;
      }
      final encoder = JsonEncoder.withIndent('  ');
      final prettyString = encoder.convert(data);
      // Because `debugPrint` might truncate very long strings, 
      // sometimes we split, but for reasonable payloads this works:
      prettyString.split('\n').forEach((line) => debugPrint(line));
    } catch (e) {
      // If it's not JSON encodable (e.g. plain text response), just print it
      debugPrint(data.toString());
    }
  }
}
