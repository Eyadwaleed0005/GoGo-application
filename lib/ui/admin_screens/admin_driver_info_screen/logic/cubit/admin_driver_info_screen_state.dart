part of 'admin_driver_info_screen_cubit.dart';

@immutable
sealed class AdminDriverInfoScreenState {}

final class AdminDriverInfoScreenInitial extends AdminDriverInfoScreenState {}

final class AdminDriverInfoScreenLoading extends AdminDriverInfoScreenState {}

final class AdminDriverInfoScreenLoaded extends AdminDriverInfoScreenState {
  final DriverModel driver;
  final List<DriverHistoryModel> history;

  AdminDriverInfoScreenLoaded(this.driver, this.history);
}

final class AdminDriverInfoScreenError extends AdminDriverInfoScreenState {
  final String message;

  AdminDriverInfoScreenError(this.message);
}
