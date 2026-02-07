import 'dart:convert';

class DriverLocationPostDto {
  final String driverId;
  final double lat;
  final double lng;
  final DateTime timestamp;
  final double? speed;
  final double? heading;
  final double? accuracy;

  DriverLocationPostDto({
    required this.driverId,
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.speed,
    this.heading,
    this.accuracy,
  });

  factory DriverLocationPostDto.fromJson(Map<String, dynamic> json) {
    return DriverLocationPostDto(
      driverId: json['driverId'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      speed: json['speed'] != null ? (json['speed'] as num).toDouble() : null,
      heading: json['heading'] != null ? (json['heading'] as num).toDouble() : null,
      accuracy: json['accuracy'] != null ? (json['accuracy'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "driverId": driverId,
      "lat": lat,
      "lng": lng,
      "timestamp": timestamp.toIso8601String(),
      if (speed != null) "speed": speed,
      if (heading != null) "heading": heading,
      if (accuracy != null) "accuracy": accuracy,
    };
  }

  String toRawJson() => jsonEncode(toJson());

  factory DriverLocationPostDto.fromRawJson(String str) =>
      DriverLocationPostDto.fromJson(jsonDecode(str));
}
