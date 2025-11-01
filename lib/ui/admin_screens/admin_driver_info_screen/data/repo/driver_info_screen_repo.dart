import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/model/driver_history_model.dart';

class DriverInfoRepo {
  Future<Either<String, DriverModel>> getDriverByUserId(String userId) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getDriverData(userId),
      );
      final driver = DriverModel.fromJson(response.data);
      return Right(driver);
    } on DioException catch (error) {
      final errorMessage = DioExceptionHandler.handleDioError(error);
      return Left(errorMessage);
    } catch (error) {
      return Left(error.toString());
    }
  }

  Future<Either<String, List<DriverHistoryModel>>> getDriverHistory(
      String userId) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getDriverHistory(userId),
      );
      final history = DriverHistoryModel.fromJsonList(response.data);
      return Right(history);
    } on DioException catch (error) {
      final errorMessage = DioExceptionHandler.handleDioError(error);
      return Left(errorMessage);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
