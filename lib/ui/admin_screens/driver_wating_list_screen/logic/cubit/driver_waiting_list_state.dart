part of 'driver_waiting_list_cubit.dart';

@immutable
sealed class DriverWaitingListState {}

final class DriverWaitingListInitial extends DriverWaitingListState {}

final class DriverWaitingListLoading extends DriverWaitingListState {}

final class DriverWaitingListLoaded extends DriverWaitingListState {
  final List<DriverWaitingListModel> drivers;
  DriverWaitingListLoaded(this.drivers);
}

final class DriverWaitingListError extends DriverWaitingListState {
  final String message;
  DriverWaitingListError(this.message);
}
