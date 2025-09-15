import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/foundation.dart';

class MapRepository {
  Future<List<MapSuggestion>> getPlaceSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await DioHelper.getData(
        url: "${EndPoints.geocoding}/$query.json",
        query: {
          'access_token': EndPoints.accessToken,
          'autocomplete': 'true',
          'limit': '5',
          'country': 'EG',
        },
      );

      final List features = response.data['features'] ?? [];
      return features.map<MapSuggestion>((item) {
        return MapSuggestion.fromJson(item);
      }).toList();
    } catch (e) {
      if (e is DioException) {
        debugPrint("❌ getPlaceSuggestions Error: ${DioExceptionHandler.handleDioError(e)}");
      } else {
        debugPrint("❌ Unexpected error in getPlaceSuggestions: $e");
      }
      return [];
    }
  }

  Future<String> getPlaceName(Point point) async {
    try {
      final response = await DioHelper.getData(
        url: "${EndPoints.geocoding}/${point.coordinates.lng},${point.coordinates.lat}.json",
        query: {
          'access_token': EndPoints.accessToken,
          'country': 'EG',
        },
      );

      if (response.data['features'] != null &&
          response.data['features'].isNotEmpty) {
        return response.data['features'][0]['place_name'];
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("❌ getPlaceName Error: ${DioExceptionHandler.handleDioError(e)}");
      } else {
        debugPrint("❌ Unexpected error in getPlaceName: $e");
      }
    }
    return '';
  }

  Future<({
  List<Point> routePoints,
  double distanceKm,
  double durationMin,
})?> getRoute(Point from, Point to) async {
  try {
    // استدعاء API من Mapbox للحصول على بيانات الاتجاهات
    final response = await DioHelper.getData(
      url:
          "${EndPoints.directions}/${from.coordinates.lng},${from.coordinates.lat};${to.coordinates.lng},${to.coordinates.lat}.json",
      query: {
        'geometries': 'geojson', // للحصول على الإحداثيات بصيغة GeoJSON
        'overview': 'full',      // المسار بالكامل
        'access_token': EndPoints.accessToken,
      },
    );

    final data = response.data;

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      final route = data['routes'][0];
      final coords = route['geometry']['coordinates'] as List;

      // تحويل الإحداثيات إلى List<Point> باستخدام compute لتفادي تجميد واجهة المستخدم
      final points = await compute<List, List<Point>>(
        _parseRoute,
        coords,
      );

      // المسافة بالمتر
      final distanceMeters = (route['distance'] as num).toDouble();
      // الوقت بالثواني
      final durationSeconds = (route['duration'] as num).toDouble();

      return (
        routePoints: points,
        distanceKm: distanceMeters / 1000,    // التحويل من متر إلى كيلومتر
        durationMin: durationSeconds / 60,    // التحويل من ثانية إلى دقيقة
      );
    }
  } catch (e) {
    if (e is DioException) {
      debugPrint("❌ getRoute Error: ${DioExceptionHandler.handleDioError(e)}");
    } else {
      debugPrint("❌ Unexpected error in getRoute: $e");
    }
  }

  return null;
}

// دالة مساعدة لتحويل الإحداثيات من JSON إلى List<Point>
static List<Point> _parseRoute(List coords) {
  return coords.map<Point>((c) {
    return Point(
      coordinates: Position(
        (c[0] as num).toDouble(), // lng
        (c[1] as num).toDouble(), // lat
      ),
    );
  }).toList();
}

}
