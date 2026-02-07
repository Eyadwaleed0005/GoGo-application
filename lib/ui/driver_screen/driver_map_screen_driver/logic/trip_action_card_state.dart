part of 'trip_action_card_cubit.dart';

@immutable
sealed class TripActionCardState {}

final class TripActionCardInitial extends TripActionCardState {}

final class TripActionCardLoading extends TripActionCardState {}

final class TripActionCardUpdated extends TripActionCardState {
  final RideModel ride;
  final bool isDestination;

  TripActionCardUpdated({
    required this.ride,
    required this.isDestination,
  });
}

final class TripActionCardError extends TripActionCardState {
  final String message;
  final bool isDestination;

  TripActionCardError({
    required this.message,
    required this.isDestination,
  });
}

final class TripActionCardCall extends TripActionCardState {
  final String phone;
  TripActionCardCall(this.phone);
}

final class TripActionCardWhatsApp extends TripActionCardState {
  final String phone;
  final String message;
  TripActionCardWhatsApp(this.phone, this.message);
}

final class TripActionCardSuccess extends TripActionCardState {}
