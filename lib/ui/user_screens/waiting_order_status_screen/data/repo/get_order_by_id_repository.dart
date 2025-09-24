import 'package:dio/dio.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });
}

class GetOrderByIdRepository {
  Future<GetAllOrdersModel?> getOrderById() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderId = prefs.getInt(SharedPreferenceKeys.userOrderId);
      if (orderId == null) return null;

      final response = await DioHelper.getData(
        url: EndPoints.getOrderById(orderId),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final order = GetAllOrdersModel.fromJson(data);

        if (order.status != null) {
          await prefs.setString(SharedPreferenceKeys.orderStatus, order.status!);
        }
        if (order.driverId != null) {
          await prefs.setInt(SharedPreferenceKeys.driverIdTrip, order.driverId!);
        }

        return order;
      } else {
        return null;
      }
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  Future<ApiResponse<void>> clearOrder() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getInt(SharedPreferenceKeys.userOrderId);
    if (orderId == null) {
      return ApiResponse(
        success: false,
        message: "لا يوجد طلب لإلغائه",
      );
    }

    final response = await DioHelper.deleteData(
      url: EndPoints.deleteOrder(orderId),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await prefs.remove(SharedPreferenceKeys.userOrderId);
      await prefs.remove(SharedPreferenceKeys.orderStatus);
      await prefs.remove(SharedPreferenceKeys.driverIdTrip);

      final message = (response.data is Map<String, dynamic> &&
              response.data["message"] != null)
          ? response.data["message"]
          : "تم إلغاء الطلب بنجاح";

      return ApiResponse(
        success: true,
        message: message,
      );
    } else {
      return ApiResponse(
        success: false,
        message: response.statusMessage ?? "فشل في إلغاء الطلب",
      );
    }
  } on DioException catch (error) {
    final handledError = DioExceptionHandler.handleDioError(error);
    return ApiResponse(
      success: false,
      message: handledError,
    );
  }
}

}
