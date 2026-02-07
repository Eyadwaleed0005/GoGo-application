import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/data/model/driver_status_update_model.dart';

class DriverStatusRepository {
  Future<String> updateDriverStatus({
    required int driverId, // 👈 هنستقبل DriverId هنا
    required DriverStatusUpdateModel model,
  }) async {
    try {
      final response = await DioHelper.putData(
        url: EndPoints.updateDriverStatus(driverId),
        data: model.toJson(),
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey("message")) {
          return data["message"];
        }
      }

      if (response.data is String) {
        return response.data;
      }

      return "Unexpected response format";
    } on DioException catch (error) {
      return DioExceptionHandler.handleDioError(error);
    } catch (e) {
      return e.toString();
    }
  }
}
