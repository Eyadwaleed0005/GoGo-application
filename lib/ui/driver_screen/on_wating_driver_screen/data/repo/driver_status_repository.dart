import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/model/driver-status-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';

class DriverStatusRepository {
  Future<DriverStatusModel> getDriverStatus() async {
    try {
      final userId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.userId,
      );
      final response = await DioHelper.getData(
        url: EndPoints.getDriverData(userId!),
      );
      final driverStatus = DriverStatusModel.fromJson(response.data);
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.driverId,
        value: driverStatus.id.toString(),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        SharedPreferenceKeys.statusOfAccountDriver,
        driverStatus.status,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.carBrand, 
        value: driverStatus.carBrand,    
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.gender,
        value: driverStatus.gender,
      );
      print("✅ DriverId: ${driverStatus.id}, Status: ${driverStatus.status}, CarBrand: ${driverStatus.carBrand}, Gender: ${driverStatus.gender}");
      return driverStatus;
    } on DioException catch (e) {
      throw Exception(DioExceptionHandler.handleDioError(e));
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
