import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/models/user_driver_response_model.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_login_screen/data/model/driver_login_request_model.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';

class DriverLoginRepository {
  Future<UserDriverResponseModel> login(DriverLoginRequestModel model) async {
    try {
      final response = await DioHelper.postData(
        url: EndPoints.loginUser,
        data: model.toJson(),
      );

      final loginResponse = UserDriverResponseModel.fromJson(response.data);

      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.userId,
        value: loginResponse.userId,
      );

      final driverResponse = await DioHelper.getData(
        url: EndPoints.getDriverData(loginResponse.userId),
      );
      final driver = DriverModel.fromJson(driverResponse.data);

      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.driverId,
        value: driver.id.toString(),
      );

      print("✅ UserId saved: ${loginResponse.userId}");
      print("✅ DriverId saved: ${driver.id}");

      return loginResponse;
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleDioError(e);
      throw message;
    } catch (e) {
      throw e.toString().replaceFirst('Exception: ', '');
    }
  }
}
