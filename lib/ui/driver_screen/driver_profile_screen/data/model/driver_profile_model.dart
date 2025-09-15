import 'package:gogo/core/models/drivers_models/driver_model.dart';

class DriverProfile {
  final String driverPhoto;
  final double review; 

  DriverProfile({
    required this.driverPhoto,
    required this.review,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      driverPhoto: json['driverPhoto'] ?? '',
      review: (json['review'] is int)
          ? (json['review'] as int).toDouble()
          : (json['review'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverPhoto': driverPhoto,
      'review': review,
    };
  }

  factory DriverProfile.fromDriverModel(DriverModel model) {
    return DriverProfile(
      driverPhoto: model.driverPhoto,
      review: model.review.toDouble(), 
    );
  }
}
