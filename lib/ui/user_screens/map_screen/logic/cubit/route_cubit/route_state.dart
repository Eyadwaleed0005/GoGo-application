import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final List<LatLng> routePoints;
  final double distanceKm;
  final double durationMin;

  RouteLoaded(
    this.routePoints, {
    required this.distanceKm,
    required this.durationMin,
  });
}

class RouteError extends RouteState {
  final String message;
  RouteError(this.message);
}

class RoutePointsSelected extends RouteState {
  final LatLng? fromPoint;
  final LatLng? toPoint;

  RoutePointsSelected({this.fromPoint, this.toPoint});
}
