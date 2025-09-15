import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/services/custom_location_servicse.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'dart:math';

class MapHelper {
  static const String _accessToken = EndPoints.accessToken;

  // حساب المسافة بالمتر بين نقطتين
  static double _distanceMeters(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371000; // نصف قطر الأرض بالمتر
    final dLat = _deg2rad(lat2 - lat1);
    final dLng = _deg2rad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double _deg2rad(double deg) => deg * pi / 180;

  static Future<String?> getNearestKnownAddress(mb.Point point) async {
    final lat = (point.coordinates[1] as num).toDouble();
    final lng = (point.coordinates[0] as num).toDouble();

    // 1️⃣ نفحص الأماكن المخصصة أولًا
    final customLocations = CustomLocationService.getCustomLocations();
    for (var loc in customLocations) {
      final distance = _distanceMeters(lat, lng, loc.latitude, loc.longitude);
      if (distance <= 500) { // أقل من 500 متر
        return loc.address ?? loc.name; // نرجع العنوان كامل من الأماكن المخصصة
      }
    }

    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$_accessToken&limit=1';

    try {
      final response = await Dio().get(url);
      if (response.data['features'] != null &&
          response.data['features'].isNotEmpty) {
        String placeName = response.data['features'][0]['place_name'];

        // إزالة رقم البريد (لو موجود)
        placeName = placeName.replaceAll(RegExp(r'\b\d{5}\b,?\s?'), '');

        // إزالة اسم الدولة (آخر جزء بعد آخر فاصلة)
        final parts = placeName.split(',');
        if (parts.length > 1) {
          parts.removeLast(); // إزالة آخر جزء (الدولة)
          placeName = parts.join(',').trim();
        }

        return placeName;
      }
    } catch (e) {
      print('Reverse geocode error: $e');
    }

    return "Unknown Place";
  }
}
