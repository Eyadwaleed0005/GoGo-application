part of 'driver_profile_screen_cubit.dart';

@immutable
abstract class DriverProfileScreenState {}

class DriverProfileScreenInitial extends DriverProfileScreenState {}

class DriverProfileScreenLoading extends DriverProfileScreenState {}

class DriverProfileScreenLoaded extends DriverProfileScreenState {
  final DriverProfile driverProfile;
  DriverProfileScreenLoaded({required this.driverProfile});
}
