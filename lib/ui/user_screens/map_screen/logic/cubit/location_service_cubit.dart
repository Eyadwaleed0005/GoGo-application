import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_places_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/driver_places_service.dart';

part 'location_service_state.dart';

class LocationServiceCubit extends Cubit<LocationServiceState> {
  StreamSubscription<ServiceStatus>? _serviceSubscription;

  LocationServiceCubit() : super(LocationServiceInitial()) {
    _monitorServiceStatus();
    checkLocationService();
  }

  Future<void> checkLocationService() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(LocationServiceDisabled());
    } else {
      emit(LocationServiceEnabled());
      // لو الخدمة مفعّلة، نجيب أماكن السواقين
      await fetchDriverPlaces();
    }
  }

  Future<void> fetchDriverPlaces() async {
    try {
      final places = await DriverPlacesService.getDriverPlaces();
      if (places != null) {
        emit(LocationServiceWithDrivers(places.drivers));
      }
      // لو null أو فشل، ما نعملش حاجة
    } catch (_) {
      // تجاهل أي خطأ عادي
    }
  }

  void _monitorServiceStatus() {
    _serviceSubscription =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.enabled) {
        emit(LocationServiceEnabled());
        fetchDriverPlaces(); // نحدث أماكن السواقين
      } else {
        emit(LocationServiceDisabled());
      }
    });
  }

  @override
  Future<void> close() {
    _serviceSubscription?.cancel();
    return super.close();
  }
}
