class RideModel {
  final double fromLat;      
  final double fromLng;
  final double toLat;        
  final double toLng;
  final String userPhone;   
  final double? distanceKm;  
  final double? durationMin; 
  final List<List<double>>? routeGeometry; 

  RideModel({
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.userPhone,
    this.distanceKm,
    this.durationMin,
    this.routeGeometry,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      fromLat: (json['fromLat'] as num).toDouble(),
      fromLng: (json['fromLng'] as num).toDouble(),
      toLat: (json['toLat'] as num).toDouble(),
      toLng: (json['toLng'] as num).toDouble(),
      userPhone: json['userPhone'] as String,
      distanceKm: json['distance'] != null
          ? (json['distance'] as num).toDouble() / 1000 
          : null,
      durationMin: json['duration'] != null
          ? (json['duration'] as num).toDouble() / 60   // تحويل من ثواني إلى دقائق
          : null,
      routeGeometry: (json['geometry'] as List?)
          ?.map((c) => [(c[0] as num).toDouble(), (c[1] as num).toDouble()])
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromLat': fromLat,
      'fromLng': fromLng,
      'toLat': toLat,
      'toLng': toLng,
      'userPhone': userPhone,
      'distanceKm': distanceKm,
      'durationMin': durationMin,
      'geometry': routeGeometry,
    };
  }

  String get distanceText => distanceKm != null
      ? "${distanceKm!.toStringAsFixed(1)} km"
      : "0 km";

  String get durationText => durationMin != null
      ? "${(durationMin! / 60).toStringAsFixed(1)} h"
      : "0 h";
}
