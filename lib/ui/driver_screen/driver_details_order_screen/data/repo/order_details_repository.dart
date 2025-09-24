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

  Future<GetAllOrdersModel?> updateOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await DioHelper.putData(
        url: EndPoints.updateOrder,
        data: orderData, 
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
}
