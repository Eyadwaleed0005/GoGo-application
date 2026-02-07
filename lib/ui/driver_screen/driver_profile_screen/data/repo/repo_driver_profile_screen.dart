import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/model/driver_profile_model.dart';

class DriverRepository {
  Future<Either<String, DriverProfile>> getDriverProfile() async {
    try {
      final userId = await SecureStorageHelper.getdata(key: SecureStorageKeys.userId);
      final response = await DioHelper.getData(
        url: EndPoints.getDriverData(userId!),
      );
      final driverModel = DriverModel.fromJson(response.data);
      final driverProfile = DriverProfile.fromDriverModel(driverModel);
      return Right(driverProfile);
    } on DioException catch (e) {
      final errorMsg = DioExceptionHandler.handleDioError(e);
      return Left(errorMsg);
    } catch (e) {
      return Left("Unexpected error: $e");
    }
  }
}
