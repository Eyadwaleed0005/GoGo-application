import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/model/driver_location_post_dto.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/repo/driver_location_service.dart';

part 'driver_location_state.dart';

class DriverLocationCubit extends Cubit<DriverLocationState> {
  Timer? _timer;

  DriverLocationCubit() : super(DriverLocationInitial());

  Future<void> startTracking(String driverId) async {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final dto = DriverLocationPostDto(
          driverId: driverId,
          lat: position.latitude,
          lng: position.longitude,
          timestamp: DateTime.now(),
          speed: position.speed,
          heading: position.heading,
          accuracy: position.accuracy,
        );

        final errorMessage = await DriverLocationService.sendLocation(dto);

        if (errorMessage == null) {
          emit(DriverLocationSuccess());
        } else {
          emit(DriverLocationError(errorMessage));
        }
      } catch (e) {
        emit(DriverLocationError("Location error: $e"));
      }
    });
  }

  void stopTracking() {
    _timer?.cancel();
    emit(DriverLocationStopped());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
