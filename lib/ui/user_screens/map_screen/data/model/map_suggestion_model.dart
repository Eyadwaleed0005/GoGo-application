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

  /// 🧩 إنشاء من JSON الخاص بجوجل Places API
  factory MapSuggestion.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;

    // 🔹 1. Google Places autocomplete
    // ممكن يرجع مكانه داخل geometry.location أو داخل structured_formatting
    if (json['geometry']?['location'] != null) {
      lat = _toDouble(json['geometry']['location']['lat']);
      lng = _toDouble(json['geometry']['location']['lng']);
    }

    // 🔹 2. Google autocomplete suggestion (بدون geometry)
    lat ??= _toDouble(json['lat']);
    lng ??= _toDouble(json['lng']);

    // 🔹 3. fallback
    lat ??= 0.0;
    lng ??= 0.0;

    // 🧹 تنظيف الاسم من الأكواد الغريبة مثل plus_code
    String name = (json['description'] ??
            json['formatted_address'] ??
            json['name'] ??
            json['place_name'] ??
            'غير معروف')
        .toString()
        .trim();

    // ✅ لو العنوان فيه plus code زي "8562+M59" نستبعده
    if (name.contains('+')) {
      name = name.replaceAll(RegExp(r'[A-Z0-9+]+،?'), '').trim();
    }

    return MapSuggestion(
      id: (json['place_id'] ?? json['id'] ?? '').toString(),
      name: name,
      latitude: lat,
      longitude: lng,
      address: json['formatted_address']?.toString() ?? name,
    );
  }

  /// 🧩 تحويل إلى JSON (لو هتبعتها للسيرفر)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      };

  /// 🧹 Helper آمن لتحويل أي قيمة إلى double
  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// 🏗️ Factory يدوي (مثلاً للموقع الحالي)
  factory MapSuggestion.manual({
    required String name,
    required double latitude,
    required double longitude,
  }) {
    return MapSuggestion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
