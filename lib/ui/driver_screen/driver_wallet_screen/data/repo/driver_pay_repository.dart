import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/model/driver_pay_model.dart';

class DriverPayRepository {
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

  Future<DriverPayModel> submitDriverPay({required String imageUrl}) async {
    try {
      final driverId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.driverId,
      );
      final name = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.displayName,
      );

      final driverPay = DriverPayModel(
        driverId: int.parse(driverId!),
        name: name!,
        image: imageUrl,
      );

      final response = await DioHelper.postData(
        url: EndPoints.sendDriverPay,
        data: driverPay.toJson(),
      );

      return DriverPayModel.fromJson(response.data);
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }
}
