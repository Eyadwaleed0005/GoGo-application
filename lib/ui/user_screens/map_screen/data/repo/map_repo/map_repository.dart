import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';

class MapRepository {
  Timer? _debounceTimer;
  String? _lastQuery;
  List<MapSuggestion>? _lastSuggestions;

  /// 🔍 جلب اقتراحات البحث من Google Places Autocomplete
  Future<List<MapSuggestion>> getPlaceSuggestions(String query) async {
    if (query.isEmpty) return [];

    // ✅ لو نفس الاستعلام السابق نرجّع نفس النتيجة بدون طلب جديد
    if (_lastQuery == query && _lastSuggestions != null) {
      return _lastSuggestions!;
    }

    // إلغاء أي مؤقت شغال
    _debounceTimer?.cancel();

    final completer = Completer<List<MapSuggestion>>();

    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      try {
        final response = await DioHelper.getData(
          url: EndPoints.googlePlacesAutocomplete,
          query: {
            'input': query,
            'key': EndPoints.googleMapsKey,
            'language': 'ar',
            'components': 'country:eg',
          },
        );

        final List predictions = response.data['predictions'] ?? [];
        final suggestions = predictions.map<MapSuggestion>((item) {
          return MapSuggestion(
            id: item['place_id'] ?? '',
            name: item['description'] ?? '',
            latitude: 0,
            longitude: 0,
          );
        }).toList();

        _lastQuery = query;
        _lastSuggestions = suggestions;

        completer.complete(suggestions);
      } catch (e) {
        completer.complete([]);
      }
    });

    return completer.future;
  }

  /// 📍 جلب تفاصيل المكان من Google Place Details
  Future<MapSuggestion?> getPlaceDetails(String placeId) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.googlePlaceDetails,
        query: {
          'place_id': placeId,
          'key': EndPoints.googleMapsKey,
          'language': 'ar',
        },
      );

      final result = response.data['result'];
      if (result == null) return null;

      final location = result['geometry']?['location'];

      // ✅ استخدم الاسم أو العنوان الحقيقي فقط — وتجنب كود الـ plus
      String placeName = result['name'] ??
          result['formatted_address'] ??
          result['vicinity'] ??
          '';

      // ✅ تنظيف الاسم من كود Plus مثل "4RJ3+R8J"
      placeName = placeName
          .replaceAll(RegExp(r'^[0-9A-Z]{4,}\+?[0-9A-Z]*[,، ]*'), '')
          .trim();

      // ✅ في حالة الاسم فاضي خالص نستخدم formatted_address
      if (placeName.isEmpty && result['formatted_address'] != null) {
        placeName = result['formatted_address'];
      }

      return MapSuggestion(
        id: placeId,
        name: placeName,
        latitude: (location?['lat'] as num?)?.toDouble() ?? 0,
        longitude: (location?['lng'] as num?)?.toDouble() ?? 0,
        address: placeName,
      );
    } catch (_) {
      return null;
    }
  }

 /// 🏙️ جلب اسم المكان أو العنوان التفصيلي (مع أقرب معلم لو موجود)
Future<String> getPlaceName(LatLng point) async {
  try {
    final response = await DioHelper.getData(
      url: EndPoints.googleGeocode,
      query: {
        'latlng': '${point.latitude},${point.longitude}',
        'key': EndPoints.googleMapsKey,
        'language': 'ar',
      },
    );

    final results = response.data['results'];
    if (results != null && results.isNotEmpty) {
      String? detailedName;

      // 🔍 نحاول نلاقي أقرب معلم معروف (زي مطعم، بنك، مسجد...)
      for (final result in results) {
        final types = List<String>.from(result['types'] ?? []);
        if (types.contains('point_of_interest') ||
            types.contains('establishment') ||
            types.contains('premise')) {
          detailedName = result['name'] ?? result['formatted_address'];
          break;
        }
      }

      // 🏠 لو مفيش معلم معروف، نستخدم أول عنوان كامل
      detailedName ??= results.first['formatted_address'] ?? '';

      // ✂️ نحذف أكواد Plus فقط (زي 4RJ3+R8J) لكن نسيب باقي التفاصيل
      detailedName = detailedName!
          .replaceAll(RegExp(r'^[0-9A-Z]{3,}\+?[0-9A-Z]*[,، ]*'), '')
          .trim();

      return detailedName;
    }
  } catch (_) {}

  return 'موقع غير معروف';
}

  /// 🛣️ جلب المسار بين نقطتين من Google Directions
  Future<({
    List<LatLng> routePoints,
    double distanceKm,
    double durationMin,
  })?> getRoute(LatLng from, LatLng to) async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.googleDirections,
        query: {
          'origin': '${from.latitude},${from.longitude}',
          'destination': '${to.latitude},${to.longitude}',
          'key': EndPoints.googleMapsKey,
          'language': 'ar',
          'mode': 'driving',
        },
      );

      final data = response.data;
      if (data['routes'] == null || data['routes'].isEmpty) return null;

      final route = data['routes'][0];
      final overviewPolyline = route['overview_polyline']?['points'];
      if (overviewPolyline == null) return null;

      final points = await compute<String, List<LatLng>>(
        _decodePolyline,
        overviewPolyline,
      );

      final leg = route['legs']?[0];
      if (leg == null) return null;

      final distanceMeters =
          (leg['distance']?['value'] as num?)?.toDouble() ?? 0;
      final durationSeconds =
          (leg['duration']?['value'] as num?)?.toDouble() ?? 0;

      return (
        routePoints: points,
        distanceKm: distanceMeters / 1000,
        durationMin: durationSeconds / 60,
      );
    } catch (_) {
      return null;
    }
  }

  /// 🔄 فك تشفير الـ Polyline القادم من Google Directions
  static List<LatLng> _decodePolyline(String polyline) {
    final List<LatLng> points = [];
    int index = 0, lat = 0, lng = 0;

    while (index < polyline.length) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
