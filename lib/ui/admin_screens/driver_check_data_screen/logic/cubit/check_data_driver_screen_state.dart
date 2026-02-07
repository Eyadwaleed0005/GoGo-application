part of 'check_data_driver_screen_cubit.dart';

@immutable
sealed class CheckDataDriverScreenState {}

final class CheckDataDriverScreenInitial extends CheckDataDriverScreenState {}

final class CheckDataDriverScreenLoading extends CheckDataDriverScreenState {}

final class CheckDataDriverScreenLoaded extends CheckDataDriverScreenState {
  final DriverModel driver;
  final CarModel car;

  CheckDataDriverScreenLoaded(this.driver, this.car);
}

final class CheckDataDriverScreenError extends CheckDataDriverScreenState {
  final String? message;

  CheckDataDriverScreenError([this.message]);
}

final class DriverStatusUpdateLoading extends CheckDataDriverScreenState {}

final class DriverStatusUpdateSuccess extends CheckDataDriverScreenState {
  final DriverApprovalStatus status;
  final String message;

  DriverStatusUpdateSuccess(this.status, this.message);
}


final class DriverStatusUpdateError extends CheckDataDriverScreenState {
  final String message;
  DriverStatusUpdateError(this.message);
}
