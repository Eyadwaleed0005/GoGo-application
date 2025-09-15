import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

abstract class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final List<mb.Point> routePoints;
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
  final mb.Point? fromPoint;
  final mb.Point? toPoint;

  RoutePointsSelected({this.fromPoint, this.toPoint});
}
