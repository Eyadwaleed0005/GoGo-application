part of 'driver_history_screen_cubit.dart';

@immutable
sealed class DriverHistoryScreenState {}

final class DriverHistoryScreenInitial extends DriverHistoryScreenState {}

final class DriverHistoryScreenLoading extends DriverHistoryScreenState {}

final class DriverHistoryScreenLoaded extends DriverHistoryScreenState {
  final List<DriverHistoryModel> historyList;
  DriverHistoryScreenLoaded(this.historyList);
}

final class DriverHistoryScreenError extends DriverHistoryScreenState {
  final String message;
  DriverHistoryScreenError(this.message);
}
