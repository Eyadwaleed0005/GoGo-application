import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/data/model/login_request_model.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/data/model/login_response_model.dart';

class LoginRepository {
  Future<LoginResponseModel> login(LoginRequestModel model) async {
    try {
      final response = await DioHelper.postData(
        url: EndPoints.loginUser,
        data: model.toJson(),
      );
      final loginResponse = LoginResponseModel.fromJson(response.data);
      return loginResponse;
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleDioError(e);
      throw message;
    } catch (e) {
      throw e.toString().replaceFirst('Exception: ', '');
    }
  }
}
