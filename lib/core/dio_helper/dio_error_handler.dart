import 'package:dio/dio.dart';
import 'package:gogo/core/dio_helper/model/error_model.dart';

class DioExceptionHandler {
  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return "Request to the server was cancelled.";
      case DioExceptionType.connectionTimeout:
        return "Connection timeout with the server.";
      case DioExceptionType.sendTimeout:
        return "Send timeout in connection with the server.";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout in connection with the server.";
      case DioExceptionType.connectionError:
        return "⚠️ Connection Error. Please check your internet connection.";

      case DioExceptionType.badResponse:
        {
          final response = error.response;
          if (response != null && response.data != null) {
            try {
              final errorModel = ErrorModel.fromJson(response.data);
              if (errorModel.message != null && errorModel.message!.isNotEmpty) {
                return errorModel.message!;
              }
            } catch (_) {
              if (response.data is String) {
                return response.data;
              }
            }
            switch (response.statusCode) {
              case 400:
                return "Bad request.";
              case 401:
                return "Unauthorized. Please login again.";
              case 403:
                return "Forbidden request.";
              case 404:
                return "Not found.";
              case 405:
                return "Method not allowed.";
              case 408:
                return "Request timeout.";
              case 500:
                return "Internal server error.";
              case 502:
                return "Bad gateway.";
              case 503:
                return "Service unavailable.";
              case 504:
                return "Gateway timeout.";
              default:
                return "Cannot find this error.";
            }
          }
          return "Bad response error: ${error.message}";
        }

      case DioExceptionType.unknown:
        return "Unexpected error occurred: ${error.message}";

      default:
        return "Something went wrong.";
    }
  }
}
