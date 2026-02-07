import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';

class GetAllOrdersRepository {
  Future<List<GetAllOrdersModel>> getAllOrders() async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getAllOrders,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey(r'$values')) {
        final List<dynamic> values = data[r'$values'] ?? [];
        return values.map((e) => GetAllOrdersModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }
}
