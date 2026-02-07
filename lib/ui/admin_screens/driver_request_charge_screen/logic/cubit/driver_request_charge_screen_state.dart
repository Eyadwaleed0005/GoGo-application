part of 'driver_request_charge_screen_cubit.dart';

@immutable
sealed class DriverRequestChargeScreenState {}

final class DriverRequestChargeScreenInitial extends DriverRequestChargeScreenState {}

final class DriverRequestChargeLoading extends DriverRequestChargeScreenState {}

final class DriverRequestChargeLoaded extends DriverRequestChargeScreenState {
  final List<TopUpDriver> requests;
  DriverRequestChargeLoaded(this.requests);
}

final class DriverRequestChargeError extends DriverRequestChargeScreenState {
  final String message;
  DriverRequestChargeError(this.message);
}

final class DriverRequestChargeActionLoading extends DriverRequestChargeScreenState {}

final class DriverRequestChargeActionSuccess extends DriverRequestChargeScreenState {}

final class DriverRequestChargeActionError extends DriverRequestChargeScreenState {
  final String message;
  DriverRequestChargeActionError(this.message);
}
