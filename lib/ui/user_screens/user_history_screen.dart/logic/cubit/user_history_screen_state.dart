part of 'user_history_screen_cubit.dart';

@immutable
sealed class UserHistoryScreenState {}

final class UserHistoryScreenInitial extends UserHistoryScreenState {}

final class UserHistoryScreenLoading extends UserHistoryScreenState {}

final class UserHistoryScreenSuccess extends UserHistoryScreenState {
  final List<UserHistory> history;
  UserHistoryScreenSuccess(this.history);
}

final class UserHistoryScreenEmpty extends UserHistoryScreenState {}

final class UserHistoryScreenFailure extends UserHistoryScreenState {
  final String error;
  UserHistoryScreenFailure(this.error);
}
