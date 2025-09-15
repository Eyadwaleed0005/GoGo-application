import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/model/driver_pay_model.dart';

class DriverPayRepository {
  final String imgbbApiKey = "1355d1f1fc6f9f68ebec37534efdcb61";
  Future<String?> uploadImage(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await Dio().post(
        "https://api.imgbb.com/1/upload?key=$imgbbApiKey",
        data: formData,
      );

      return response.data["data"]["display_url"];
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
