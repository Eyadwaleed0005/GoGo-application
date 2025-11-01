import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/driver_places_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_service_state.dart';

class LocationServiceCubit extends Cubit<LocationServiceState> {
  StreamSubscription<ServiceStatus>? _serviceSubscription;
  String? orderStatus;
  Timer? _driverPolling;

  LocationServiceCubit() : super(LocationServiceInitial()) {
    _initOrderStatus();
    _monitorServiceStatus();
    checkLocationService();
  }

  void safeEmit(LocationServiceState state) {
    if (!isClosed) emit(state);
  }

  Future<void> _initOrderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    orderStatus = prefs.getString("orderStatus") ?? "cancel";
    safeEmit(LocationServiceOrderUpdated(orderStatus!));
  }

  Future<void> checkLocationService() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      safeEmit(LocationServiceDisabled());
    } else {
      safeEmit(LocationServiceEnabled());
      await _fetchBasedOnOrderStatus();
    }
  }

  Future<void> _fetchBasedOnOrderStatus() async {
    if (orderStatus == "approve") {
      await fetchSingleDriverPlace();
      startDriverTracking();
    } else {
      await fetchAllDriverPlaces();
      stopDriverTracking();
    }
  }

  Future<void> fetchAllDriverPlaces() async {
    final places = await DriverPlacesService.getDriverPlaces();
    if (places != null) {
      safeEmit(LocationServiceWithDrivers(places.drivers));
    }
  }

  Future<void> fetchSingleDriverPlace() async {
    final driver = await DriverPlacesService.getDriverPlaceFromPrefs();
    if (driver != null) {
      safeEmit(LocationServiceWithSingleDriver(driver));
    }
  }

  Future<void> updateOrderStatus(String status) async {
    orderStatus = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("orderStatus", status);

    if (orderStatus == "approve") {
      startDriverTracking();
    } else {
      stopDriverTracking();
    }

    safeEmit(LocationServiceOrderUpdated(orderStatus!));
    await _fetchBasedOnOrderStatus();
  }

  void _monitorServiceStatus() {
    _serviceSubscription =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.enabled) {
        safeEmit(LocationServiceEnabled());
        _fetchBasedOnOrderStatus();
      } else {
        safeEmit(LocationServiceDisabled());
      }
    });
  }

  Future<void> startDriverTracking() async {
    _driverPolling?.cancel();
    _driverPolling = Timer.periodic(const Duration(seconds: 20), (_) async {
      final driver = await DriverPlacesService.getDriverPlaceFromPrefs();
      if (driver != null) {
        safeEmit(LocationServiceWithSingleDriver(driver));
      }
    });
  }

  void stopDriverTracking() {
    _driverPolling?.cancel();
  }

  @override
  Future<void> close() {
    stopDriverTracking();
    _serviceSubscription?.cancel();
    return super.close();
  }
}
