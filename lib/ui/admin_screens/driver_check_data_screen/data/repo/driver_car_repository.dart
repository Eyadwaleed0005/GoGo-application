import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/models/car_models/car_model.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';

class DriverCarRepository {
  Future<CarModel?> getCarByDriverId(int driverId) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getCarData(driverId),
      );
      return CarModel.fromJson(response.data);
    } on DioException catch (error) {
      final errorMessage = DioExceptionHandler.handleDioError(error);
      throw Exception(errorMessage);
    }
  }

  Future<DriverModel?> getDriverByUserId(String userId) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getDriverData(userId),
      );
      return DriverModel.fromJson(response.data);
    } on DioException catch (error) {
      final errorMessage = DioExceptionHandler.handleDioError(error);
      throw Exception(errorMessage);
    }
  }

  Future<(DriverModel?, CarModel?)> getDriverAndCar({
    required int driverId,
    required String userId,
  }) async {
    try {
      final car = await getCarByDriverId(driverId);
      final driver = await getDriverByUserId(userId);
      return (driver, car);
    } catch (e) {
      rethrow; 
    }
  }
}
