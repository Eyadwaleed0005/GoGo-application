import 'package:dio/dio.dart';
import 'package:gogo/core/dio_helper/model/error_model.dart';
import 'package:easy_localization/easy_localization.dart';

class DioExceptionHandler {
  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return "request_cancelled".tr();
      case DioExceptionType.connectionTimeout:
        return "connection_timeout".tr();
      case DioExceptionType.sendTimeout:
        return "send_timeout".tr();
      case DioExceptionType.receiveTimeout:
        return "receive_timeout".tr();
      case DioExceptionType.connectionError:
        return "connection_error".tr();

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
                return "bad_request".tr();
              case 401:
                return "unauthorized".tr();
              case 403:
                return "forbidden".tr();
              case 404:
                return "not_found".tr();
              case 405:
                return "method_not_allowed".tr();
              case 408:
                return "request_timeout_error".tr();
              case 500:
                return "internal_server_error".tr();
              case 502:
                return "bad_gateway".tr();
              case 503:
                return "service_unavailable".tr();
              case 504:
                return "gateway_timeout".tr();
              default:
                return "unknown_error".tr();
            }
          }
          return "${"bad_response_error".tr()}: ${error.message}";
        }

      case DioExceptionType.unknown:
        return "${"unexpected_error".tr()}: ${error.message}";

      default:
        return "something_went_wrong".tr();
    }
  }
}
