class DriverLocationPostDto {
  final String driverId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? speed;
  final double? heading;
  final double? accuracy;

  DriverLocationPostDto({
    required this.driverId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.speed,
    this.heading,
    this.accuracy,
  });
}
