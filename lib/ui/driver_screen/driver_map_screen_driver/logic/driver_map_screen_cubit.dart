import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/model/ride_model.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_ride_repository.dart';
import 'package:meta/meta.dart';
part 'driver_map_screen_state.dart';

class DriverMapScreenCubit extends Cubit<DriverMapScreenState> {
  final DriverRideRepository repository;
  bool _wasOnDestination = false;

  DriverMapScreenCubit(this.repository) : super(DriverMapScreenInitial());

  Future<Position?> _tryGetCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchRouteToCustomer({
    required double customerLat,
    required double customerLng,
    required String customerPhone,
  }) async {
    if (isClosed) return;
    emit(DriverMapScreenLoading());

    try {
      _wasOnDestination = false;
      final pos = await _tryGetCurrentPosition();
      if (isClosed) return;

      if (pos == null) {
        emit(
          DriverMapScreenError(
            "خدمة الموقع غير مفعلة",
            wasOnDestination: _wasOnDestination,
          ),
        );
        return;
      }

      final ride = await repository.getRoute(
        fromLat: pos.latitude,
        fromLng: pos.longitude,
        toLat: customerLat,
        toLng: customerLng,
        userPhone: customerPhone,
      );

      if (isClosed) return;
      emit(DriverMapScreenCustomerRouteLoaded(
        ride,
        distance: ride.distanceText,
        duration: ride.durationText,
      ));
    } catch (e) {
      if (!isClosed) {
        emit(
          DriverMapScreenError(
            e.toString(),
            wasOnDestination: _wasOnDestination,
          ),
        );
      }
    }
  }

  Future<Position?> centerCameraOnDriver() async {
    try {
      return await _tryGetCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchRouteToDestination({
    required double destinationLat,
    required double destinationLng,
    required String customerPhone,
  }) async {
    if (isClosed) return;
    emit(DriverMapScreenLoading());

    try {
      _wasOnDestination = true;
      final pos = await _tryGetCurrentPosition();
      if (isClosed) return;

      if (pos == null) {
        emit(
          DriverMapScreenError(
            "خدمة الموقع غير مفعلة",
            wasOnDestination: _wasOnDestination,
          ),
        );
        return;
      }

      final ride = await repository.getRoute(
        fromLat: pos.latitude,
        fromLng: pos.longitude,
        toLat: destinationLat,
        toLng: destinationLng,
        userPhone: customerPhone,
      );

      if (isClosed) return;
      emit(DriverMapScreenDestinationRouteLoaded(
        ride,
        distance: ride.distanceText,
        duration: ride.durationText,
      ));
    } catch (e) {
      if (!isClosed) {
        emit(
          DriverMapScreenError(
            e.toString(),
            wasOnDestination: _wasOnDestination,
          ),
        );
      }
    }
  }
}
