part of 'location_service_cubit.dart';

abstract class LocationServiceState {}

class LocationServiceInitial extends LocationServiceState {}

class LocationServiceEnabled extends LocationServiceState {}

class LocationServiceDisabled extends LocationServiceState {}

class LocationServiceWithDrivers extends LocationServiceState {
  final List<DriverPlace> drivers;

  LocationServiceWithDrivers(this.drivers);
}
