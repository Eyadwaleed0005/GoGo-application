// driver_place_model.dart
class DriverPlace {
  final int driverId;
  final String driverName;
  final double lat;
  final double lng;
  final DateTime lastUpdate;
  final bool isOnline;

  DriverPlace({
    required this.driverId,
    required this.driverName,
    required this.lat,
    required this.lng,
    required this.lastUpdate,
    required this.isOnline,
  });

  factory DriverPlace.fromJson(Map<String, dynamic> json) {
    return DriverPlace(
      driverId: json['driverId'] as int,
      driverName: json['driverName'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
      isOnline: json['isOnline'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'driverName': driverName,
      'lat': lat,
      'lng': lng,
      'lastUpdate': lastUpdate.toIso8601String(),
      'isOnline': isOnline,
    };
  }
}

class DriverPlacesResponse {
  final List<DriverPlace> drivers;

  DriverPlacesResponse({required this.drivers});

  factory DriverPlacesResponse.fromJson(Map<String, dynamic> json) {
    final values = json['\$values'] as List<dynamic>? ?? [];
    return DriverPlacesResponse(
      drivers: values.map((e) => DriverPlace.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$values': drivers.map((e) => e.toJson()).toList(),
    };
  }
}
