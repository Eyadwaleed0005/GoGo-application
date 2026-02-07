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
          "${EndPoints.googleDirections}?origin=$fromLat,$fromLng&destination=$toLat,$toLng&key=${EndPoints.googleMapsKey}";

      final response = await DioHelper.getData(url: url);
      final data = response.data;

      if (data['routes'] == null || data['routes'].isEmpty) {
        throw "No routes found from Google Directions API";
      }

      final route = data['routes'][0];
      final leg = route['legs'][0];

      /// ✅ بدلاً من overview_polyline استخدم الخطوات التفصيلية
      List<List<double>> allCoords = [];

      if (leg['steps'] != null) {
        for (var step in leg['steps']) {
          final stepPolyline = step['polyline']['points'];
          final stepCoords = _decodePolyline(stepPolyline);
          allCoords.addAll(stepCoords);
        }
      }

      /// 🔹 إجمالي المسافة والمدة
      final distanceMeters = (leg['distance']['value'] as num).toDouble();
      final durationSeconds = (leg['duration']['value'] as num).toDouble();

      return RideModel(
        fromLat: fromLat,
        fromLng: fromLng,
        toLat: toLat,
        toLng: toLng,
        userPhone: userPhone,
        distanceKm: distanceMeters / 1000,
        durationMin: durationSeconds / 60,
        routeGeometry: allCoords, // 👈 الطريق كامل شارع بشارع
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  /// 🔹 فك ترميز الـ polyline
  List<List<double>> _decodePolyline(String encoded) {
    List<List<double>> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      polyline.add([longitude, latitude]);
    }

    return polyline;
  }
}
