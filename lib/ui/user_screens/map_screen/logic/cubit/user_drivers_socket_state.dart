import 'package:gogo/ui/user_screens/map_screen/data/model/driver_places_model.dart';

abstract class UserDriversSocketState {}

class UserDriversSocketInitial extends UserDriversSocketState {}

class UserDriversSocketConnecting extends UserDriversSocketState {}

class UserDriversSocketConnected extends UserDriversSocketState {}

class UserDriversSocketDriversUpdated extends UserDriversSocketState {
  final List<DriverPlace> drivers;
  final int? followDriverId;
  UserDriversSocketDriversUpdated(this.drivers, this.followDriverId);
}
