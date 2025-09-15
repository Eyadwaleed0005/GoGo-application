import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/model/driver_location_post_dto.dart';

class DriverLocationService {

  static Future<String?> sendLocation(DriverLocationPostDto dto) async {
    try {
      await DioHelper.postData(
        url: EndPoints.updateDriverLocation,
        data: dto.toJson(),
      );
      return null; 
    } on DioException catch (e) {
      return DioExceptionHandler.handleDioError(e);
    } catch (e) {
      return  e.toString();
    }
  }
}
