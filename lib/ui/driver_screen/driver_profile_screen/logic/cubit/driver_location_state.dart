part of 'driver_location_cubit.dart';

@immutable
abstract class DriverLocationState {}

class DriverLocationInitial extends DriverLocationState {}

class DriverLocationSuccess extends DriverLocationState {}

class DriverLocationError extends DriverLocationState {
  final String message;
  DriverLocationError(this.message);
}

class DriverLocationStopped extends DriverLocationState {}
