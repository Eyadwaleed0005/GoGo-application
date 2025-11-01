part of 'admin_driver_stats_screen_cubit.dart';

@immutable
sealed class AdminDriverStatsScreenState {}

final class AdminDriverStatsScreenInitial extends AdminDriverStatsScreenState {}

final class AdminDriverStatsScreenLoading extends AdminDriverStatsScreenState {}

final class AdminDriverStatsScreenLoaded extends AdminDriverStatsScreenState {
  final List<DriverModel> drivers;
  AdminDriverStatsScreenLoaded(this.drivers);
}

final class AdminDriverStatsScreenError extends AdminDriverStatsScreenState {
  final String message;
  AdminDriverStatsScreenError(this.message);
}
