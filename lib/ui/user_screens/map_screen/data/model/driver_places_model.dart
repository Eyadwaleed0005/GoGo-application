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
      driverId: (json['driverId'] as num).toInt(),
      driverName: (json['driverName'] ?? '').toString(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      lastUpdate: DateTime.parse((json['lastUpdate'] ?? DateTime.now().toUtc().toIso8601String()).toString()),
      isOnline: (json['isOnline'] ?? true) as bool,
    );
  }

  factory DriverPlace.fromWs(Map<String, dynamic> json) {
    return DriverPlace.fromJson(json);
  }

  DriverPlace copyWith({
    int? driverId,
    String? driverName,
    double? lat,
    double? lng,
    DateTime? lastUpdate,
    bool? isOnline,
  }) {
    return DriverPlace(
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'driverName': driverName,
      'lat': lat,
      'lng': lng,
      'lastUpdate': lastUpdate.toUtc().toIso8601String(),
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
      drivers: values.whereType<Map<String, dynamic>>().map((e) => DriverPlace.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$values': drivers.map((e) => e.toJson()).toList(),
    };
  }
}
