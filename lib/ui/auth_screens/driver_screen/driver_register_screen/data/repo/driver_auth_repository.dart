import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/models/user_driver_response_model.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/data/model/register_request_model.dart';

class DriverAuthRepository {
  Future<UserDriverResponseModel> register(RegisterRequestModel model) async {
    try {
      final response = await DioHelper.postData(
        url: EndPoints.registerUser,
        data: model.toJson(),
      );

      final registerResponse = UserDriverResponseModel.fromJson(response.data);

      return registerResponse;
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleDioError(e);
      throw message;
    } catch (e) {
      throw e.toString().replaceFirst('Exception: ', '');
    }
  }
}
