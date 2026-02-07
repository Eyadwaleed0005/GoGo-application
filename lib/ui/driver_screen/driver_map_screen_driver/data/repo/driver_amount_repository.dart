import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/model/driver_amount.dart';

class DriverAmountRepository {
  Future<void> deductAmount(int amount) async {
    try {
      final driverIdString = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.driverId,
      );

      final driverAmount = DriverAmount(
        driverId: int.parse(driverIdString!),
        amount: amount,
      );

      await DioHelper.putData(
        url: EndPoints.deductDriverAmount,
        data: driverAmount.toJson(),
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioError(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
