part of 'on_wating_driver_screen_cubit.dart';

@immutable
sealed class OnWatingDriverScreenState {}

final class OnWatingDriverScreenInitial extends OnWatingDriverScreenState {}

final class OnWatingDriverScreenLoading extends OnWatingDriverScreenState {}

final class OnWatingDriverScreenSuccess extends OnWatingDriverScreenState {
  final DriverStatusModel status;
  OnWatingDriverScreenSuccess({required this.status});
}

final class OnWatingDriverScreenFailure extends OnWatingDriverScreenState {
  final String errorMessage;
  OnWatingDriverScreenFailure({required this.errorMessage});
}
