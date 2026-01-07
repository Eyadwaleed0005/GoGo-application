part of 'driver_location_cubit.dart';

@immutable
abstract class DriverLocationState {}

class DriverLocationInitial extends DriverLocationState {}

class DriverLocationRunning extends DriverLocationState {}

class DriverLocationStopped extends DriverLocationState {}
