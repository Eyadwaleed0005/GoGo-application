import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/core/api/end_points.dart';

class MapHelper {
  /// 🔑 مفتاح Google Maps API من ملف EndPoints
  static const String _apiKey = EndPoints.googleMapsKey;

  /// 📍 جلب أقرب عنوان معروف من Google Maps (Reverse Geocoding)
  static Future<String?> getNearestKnownAddress(LatLng point) async {
    final lat = point.latitude;
    final lng = point.longitude;

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_apiKey&language=ar';

    try {
      final response = await Dio().get(url);

      if (response.data['results'] != null &&
          response.data['results'].isNotEmpty) {
        String placeName = response.data['results'][0]['formatted_address'];

        // 🔹 إزالة أرقام البريد ZIP codes
        placeName = placeName.replaceAll(RegExp(r'\b\d{5,}\b'), '').trim();

        // 🔹 إزالة الدولة من النهاية لو العنوان طويل
        final parts = placeName.split(',');
        if (parts.length > 1) {
          final last = parts.last.trim();
          if (last.length < 25) {
            parts.removeLast();
          }
          placeName = parts.join(',').trim();
        }

        return placeName;
      }
    } catch (_) {
      // بدون أي طباعة أو لوجات
    }

    return "موقع غير معروف";
  }
}
