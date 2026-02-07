part of 'driver_map_screen_cubit.dart';

@immutable
abstract class DriverMapScreenState {}

class DriverMapScreenInitial extends DriverMapScreenState {}

class DriverMapScreenLoading extends DriverMapScreenState {}

class DriverMapScreenError extends DriverMapScreenState {
  final String message;
  final bool wasOnDestination;
  DriverMapScreenError(this.message, {required this.wasOnDestination});
}

class DriverMapScreenCustomerRouteLoaded extends DriverMapScreenState {
  final RideModel ride;
  final String distance; 
  final String duration; 

  DriverMapScreenCustomerRouteLoaded(
    this.ride, {
    required this.distance,
    required this.duration,
  });
}

class DriverMapScreenDestinationRouteLoaded extends DriverMapScreenState {
  final RideModel ride;
  final String distance;
  final String duration;

  DriverMapScreenDestinationRouteLoaded(
    this.ride, {
    required this.distance,
    required this.duration,
  });
}
