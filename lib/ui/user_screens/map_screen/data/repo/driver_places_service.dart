import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_places_model.dart';

class DriverPlacesService {
  static Future<DriverPlacesResponse?> getDriverPlaces() async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getDriverPlaces,
      );
      return DriverPlacesResponse.fromJson(response.data);
    } on DioException catch (e) {
      DioExceptionHandler.handleDioError(e);
      return null;
    } catch (e) {
      return null;
    }
  }
}
