import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LatLng currentLocation;
  final String address;
  final double latitude;
  final double longitude;

  LocationLoaded({
    required this.currentLocation,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
