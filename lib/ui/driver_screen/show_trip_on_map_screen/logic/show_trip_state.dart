part of 'show_trip_cubit.dart';

abstract class ShowTripState {}

class ShowTripInitial extends ShowTripState {}

class ShowTripLoading extends ShowTripState {}

class ShowTripError extends ShowTripState {
  final String message;
  ShowTripError(this.message);
}

class ShowTripLoadedMulti extends ShowTripState {
  final Polyline polyline1;
  final Polyline polyline2;
  final double driverLat;
  final double driverLng;
  final double customerLat;
  final double customerLng;
  final double destinationLat;
  final double destinationLng;
  final double distance1Km;
  final double duration1Min;
  final double distance2Km;
  final double duration2Min;
  final BitmapDescriptor driverIcon;
  final BitmapDescriptor customerIcon;
  final BitmapDescriptor destinationIcon;

  ShowTripLoadedMulti({
    required this.polyline1,
    required this.polyline2,
    required this.driverLat,
    required this.driverLng,
    required this.customerLat,
    required this.customerLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.distance1Km,
    required this.duration1Min,
    required this.distance2Km,
    required this.duration2Min,
    required this.driverIcon,
    required this.customerIcon,
    required this.destinationIcon,
  });
}
