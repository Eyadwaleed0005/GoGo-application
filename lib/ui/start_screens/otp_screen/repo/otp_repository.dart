import 'package:dio/dio.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import '../model/otp_verify_model.dart';

class OtpRepository {
  Future<void> verifyOtp(OtpVerifyModel model) async {
    try {
      final response = await DioHelper.dio.post(
        'https://in-drive.runasp.net/api/UsersIdentity/VerifyOtp',
        data: model.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل في تأكيد OTP: ${response.data}');
      }
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleDioError(e);
      throw Exception(message);
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع: ${e.toString()}");
    }
  }
}
