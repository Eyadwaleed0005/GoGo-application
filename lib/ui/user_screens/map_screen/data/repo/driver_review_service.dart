import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewResult {
  final bool success;
  final String? message;
  ReviewResult(this.success, {this.message});
}

class DriverReviewService {
  static Future<ReviewResult> submitReview({
    required int review,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getInt(SharedPreferenceKeys.driverIdTrip);
      final orderId = prefs.getInt(SharedPreferenceKeys.userOrderId);
      final response = await DioHelper.postData(
        url: EndPoints.driverReview(driverId!),
        data: {
          "orderId": orderId,
          "review": review,
        },
      );

      if (response.statusCode == 204 || response.statusCode == 204) {
        return ReviewResult(true);
      } else {
        return ReviewResult(false, message: response.data.toString());
      }
    } on DioException catch (e) {
      DioExceptionHandler.handleDioError(e);
      return ReviewResult(false, message: "⚠️ مشكلة في الاتصال بالسيرفر");
    } catch (e) {
      return ReviewResult(false, message: "❌ خطأ داخلي: $e");
    }
  }

  
}


