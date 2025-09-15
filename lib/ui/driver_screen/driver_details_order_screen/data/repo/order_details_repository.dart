import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';

class OrderDetailsRepository {
  Future<GetAllOrdersModel?> getOrderDetails(int orderId) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getOrderDetails(orderId),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return GetAllOrdersModel.fromJson(data);
      } else {
        return null;
      }
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  Future<bool> deleteOrder(int orderId) async {
    try {
      await DioHelper.deleteData(
        url: EndPoints.deleteOrder(orderId),
      );
      return true; 
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }
}
