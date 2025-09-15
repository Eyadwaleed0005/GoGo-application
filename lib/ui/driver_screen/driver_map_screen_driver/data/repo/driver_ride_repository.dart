import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/model/ride_model.dart';

class DriverRideRepository {
  Future<RideModel> getRoute({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    required String userPhone,
  }) async {
    try {
      final url =
          "${EndPoints.directions}/$fromLng,$fromLat;$toLng,$toLat"
          "?geometries=geojson&overview=full&access_token=${EndPoints.accessToken}";

      final response = await DioHelper.getData(url: url);
      final data = response.data;

      if (data['routes'] == null || data['routes'].isEmpty) {
        throw "No routes found from Mapbox";
      }

      final route = data['routes'][0];

      final geometry = (route['geometry']['coordinates'] as List)
          .map((c) => [(c[0] as num).toDouble(), (c[1] as num).toDouble()])
          .toList();

      return RideModel(
        fromLat: fromLat,
        fromLng: fromLng,
        toLat: toLat,
        toLng: toLng,
        userPhone: userPhone,
        distanceKm: (route['distance'] as num).toDouble() / 1000,
        durationMin: (route['duration'] as num).toDouble() / 60,
        routeGeometry: geometry,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
