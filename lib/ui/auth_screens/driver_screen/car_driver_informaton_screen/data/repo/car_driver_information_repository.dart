import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/models/car_models/car_model.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/data/model/driver_auth_model.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/model/driver-status-model.dart';

class CarDriverInformationRepository {
  Future<String?> uploadImage(File file) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'upload_preset': EndPoints.cloudinaryUploadPreset,
        'folder': EndPoints.cloudinaryFolder,
      });

      final response = await Dio().post(
        EndPoints.cloudinaryUploadUrl,
        data: formData,
      );

      return response.data['secure_url'];
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  Future<void> submitCarData(CarModel car) async {
    try {
      await DioHelper.postData(
        url: EndPoints.sendDataCar,
        data: car.toJson(),
      );
      await SharedPreferencesHelper.saveBool(
        key: SharedPreferenceKeys.driverCompleteRegister,
        value: true,
      );
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  Future<DriverAuthModel> submitDriverData(DriverAuthModel driver) async {
    try {
      final response = await DioHelper.postData(
        url: EndPoints.getDataDriver,
        data: driver.toJson(),
      );

      await SharedPreferencesHelper.saveBool(
        key: SharedPreferenceKeys.driverCompleteRegister,
        value: true,
      );

      final userId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.userId,
      );

      final driverResponse = await DioHelper.getData(
        url: EndPoints.getDriverData(userId!),
      );

      final driverStatus = DriverStatusModel.fromJson(driverResponse.data);
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.driverId,
        value: driverStatus.id.toString(),
      );

      return DriverAuthModel.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }
}
