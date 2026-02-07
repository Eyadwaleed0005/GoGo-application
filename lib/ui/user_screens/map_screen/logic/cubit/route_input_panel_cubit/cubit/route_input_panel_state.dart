part of 'route_input_panel_cubit.dart';

@immutable
sealed class RouteInputPanelState {}

final class RouteInputPanelInitial extends RouteInputPanelState {}

final class RouteInputPanelLoading extends RouteInputPanelState {}

final class RouteInputPanelSuccess extends RouteInputPanelState {
  final String from;
  final String to;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final double distanceKm;
  final double durationMin;

  RouteInputPanelSuccess({
    required this.from,
    required this.to,
    required this.fromLatLng,
    required this.toLatLng,
    required this.distanceKm,
    required this.durationMin,
  });
}

final class RouteInputPanelError extends RouteInputPanelState {
  final String message;
  RouteInputPanelError(this.message);
}
