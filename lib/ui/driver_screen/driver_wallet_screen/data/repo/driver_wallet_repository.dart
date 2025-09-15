import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';

class DriverWalletRepository {
  Future<int> getDriverWallet() async {
    try {
      final userId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.userId,
      );

      final response = await DioHelper.getData(
        url: EndPoints.getDriverData(userId!),
      );

      final driver = DriverModel.fromJson(response.data);
      return driver.wallet;
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }
}
