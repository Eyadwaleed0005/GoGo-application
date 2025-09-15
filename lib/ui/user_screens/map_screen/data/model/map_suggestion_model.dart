import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

class MapSuggestion {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;

  const MapSuggestion({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  /// ✅ Getter يرجع Point لماب بوكس
  mb.Point get point => mb.Point(
        coordinates: mb.Position(longitude, latitude),
      );

  /// ✅ Factory للتحويل من JSON
  factory MapSuggestion.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;

    // 1️⃣ بعض الـ APIs بترجع geometry.coordinates = [lng, lat]
    if (json['geometry']?['coordinates'] is List &&
        (json['geometry']['coordinates'] as List).length >= 2) {
      final coords = json['geometry']['coordinates'];
      lng = (coords[0] as num).toDouble();
      lat = (coords[1] as num).toDouble();
    }

    // 2️⃣ fallback لو جاية مباشرة كـ lat/lng
    lat ??= _toDouble(json['latitude'] ?? json['lat']);
    lng ??= _toDouble(json['longitude'] ?? json['lng']);

    // 3️⃣ fallback لو جاية كـ center = [lng, lat]
    if (lat == null || lng == null) {
      final center = json['center'];
      if (center is List && center.length >= 2) {
        lng ??= (center[0] as num).toDouble();
        lat ??= (center[1] as num).toDouble();
      }
    }

    return MapSuggestion(
      id: (json['id'] ?? json['place_id'] ?? '').toString(),
      name: (json['place_name'] ?? json['text'] ?? 'غير معروف').toString(),
      latitude: lat ?? 0.0,
      longitude: lng ?? 0.0,
      address: json['address']?.toString(),
    );
  }

  /// ✅ Factory مخصص للإدخال اليدوي (لما يكتب أي كلام في TextField)
  factory MapSuggestion.manual(String name) {
    return MapSuggestion(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID وهمي
      name: name,
      latitude: 0.0,
      longitude: 0.0,
      address: null,
    );
  }

  /// ✅ للتحويل إلى JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      };

  /// 🔧 Helper آمن لتحويل أي قيمة إلى double
  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
