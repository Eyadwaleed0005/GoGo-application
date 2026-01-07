part of 'trip_action_card_cubit.dart';

@immutable
abstract class TripActionCardState {}

class TripActionCardInitial extends TripActionCardState {}

class TripActionCardLoading extends TripActionCardState {}

class TripActionCardUpdated extends TripActionCardState {
  final RideModel ride;
  final bool isDestination;

  TripActionCardUpdated({required this.ride, required this.isDestination});
}

class TripActionCardSuccess extends TripActionCardState {}

class TripActionCardCall extends TripActionCardState {
  final String phone;
  TripActionCardCall(this.phone);
}

class TripActionCardError extends TripActionCardState {
  final String message;
  final bool isDestination;

  TripActionCardError({required this.message, required this.isDestination});
}
