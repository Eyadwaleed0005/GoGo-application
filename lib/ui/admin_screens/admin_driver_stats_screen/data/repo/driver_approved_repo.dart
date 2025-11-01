import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';


class DriverApprovedRepo {
  Future<Either<String, List<DriverModel>>> getAllDrivers() async {
    try {
      final response = await DioHelper.getData(url: EndPoints.getDriverapproved);
      final List<dynamic> dataList =
          response.data['\$values'] ?? response.data['data'] ?? response.data;
      final drivers = dataList
          .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(drivers);
    } on DioException catch (e) {
      final errorMessage = DioExceptionHandler.handleDioError(e);
      return Left(errorMessage);
    }
  }
}
