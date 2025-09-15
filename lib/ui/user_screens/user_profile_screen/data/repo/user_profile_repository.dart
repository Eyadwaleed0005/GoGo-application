import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/data/model/user_profile_photo_model.dart';

class UserProfileRepository {
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

      if (response.statusCode == 200) {
        return response.data["data"]["display_url"];
      }
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
    return null;
  }

  Future<void> updateUserProfile(File profileImage) async {
    try {
      final imageUrl = await uploadImage(profileImage);
      if (imageUrl == null) return;

      final userId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.userId,
      );

      await DioHelper.putData(
        url: EndPoints.updateUserImage(userId!),
        data: '"$imageUrl"',
        isRaw: true,
      );
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  Future<UserProfilePhotoModel?> getUserProfilePhoto() async {
    try {
      final userId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.userId,
      );

      final response = await DioHelper.getData(
        url: EndPoints.getUserImage(userId!),
      );

      if (response.data != null) {
        return UserProfilePhotoModel.fromJson(response.data);
      }

      return null;
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }
}
