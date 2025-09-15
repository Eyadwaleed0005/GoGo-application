import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/model/driver_history_model.dart';

class DriverHistoryRepository {
  Future<List<DriverHistoryMoedl>> getDriverHistory() async {
    try {
      final userId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.userId,
      );

      final response = await DioHelper.getData(
        url: EndPoints.getDriverHistory(userId!),
      );

      return DriverHistoryMoedl.fromJsonList(response.data);
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
