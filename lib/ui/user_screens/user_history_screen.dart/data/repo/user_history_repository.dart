import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/user_screens/user_history_screen.dart/data/model/user_history_model.dart';

class UserHistoryRepository {
  Future<List<UserHistory>> getUserHistory() async {
    try {
      final userId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.userId,
      );

      final response = await DioHelper.getData(
        url: EndPoints.getUserHistory(userId!),
      );

      if (response.data != null) {
        final data = response.data;

        if (data is Map && data.containsKey("\$values")) {
          return (data["\$values"] as List)
              .map((json) => UserHistory.fromJson(json))
              .toList();
        }
      }
      return [];
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return [];
      }
      throw DioExceptionHandler.handleDioError(error);
    }
  }
}
