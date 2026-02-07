import 'dart:async';
import 'dart:math' show min, max;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  GoogleMapController? mapController;
  final MapRepository repository;

  LatLng? currentLocation;
  List<LatLng> currentRoutePoints = [];

  // ✅ مجموعة ماركرات السواقين
  Set<Marker> _driverMarkers = {};
  Set<Marker> get driverMarkers => _driverMarkers;

  StreamSubscription<Position>? _positionStream;
  Timer? _statusTimer;
  bool _isTracking = false;

  MapCubit(this.repository) : super(MapInitial());

  void safeEmit(MapState state) {
    if (!isClosed) emit(state);
  }

  void initMap(GoogleMapController controller) {
    mapController = controller;
    safeEmit(MapReady(controller));
    startLiveTracking();
  }

  void setCurrentLocation(LatLng location) {
    currentLocation = location;
    safeEmit(MapCurrentLocationUpdated(location));
  }

  Future<void> moveCamera(
    LatLng target, {
    double zoom = 18,
    double tilt = 45,
    double bearing = 0,
  }) async {
    if (mapController == null) return;

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: zoom,
          tilt: tilt,
          bearing: bearing,
        ),
      ),
    );

    safeEmit(MapMoved(target));
  }

  Future<void> fitCameraToBounds(LatLng from, LatLng to) async {
    if (mapController == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        min(from.latitude, to.latitude),
        min(from.longitude, to.longitude),
      ),
      northeast: LatLng(
        max(from.latitude, to.latitude),
        max(from.longitude, to.longitude),
      ),
    );

    await mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 60),
    );
  }

  Future<void> drawRoute(List<LatLng> points) async {
    if (points.isEmpty) return;
    currentRoutePoints = points;
    safeEmit(MapRouteDrawn(points));
  }

  void showPinAt(LatLng point, String name) {
    safeEmit(MapPinUpdated(point, name));
  }

  Future<void> getPlaceName(double lat, double lng) async {
    final place = await repository.getPlaceName(LatLng(lat, lng));
    safeEmit(MapPlaceSelected(place));
  }

  // ✅ تحديث ماركرات السواقين في الخريطة
  void updateDriversMarkers(Set<Marker> driversMarkers) {
    _driverMarkers = driversMarkers;
    safeEmit(MapDriversUpdated(driversMarkers));
  }

  // 🛰️ ----------- REAL-TIME TRACKING SECTION ----------- 🛰️

  Future<void> startLiveTracking() async {
    if (_isTracking) return;
    _isTracking = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      safeEmit(MapError("Location services are disabled"));
      _isTracking = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        safeEmit(MapError("Location permission denied"));
        _isTracking = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      safeEmit(MapError("Location permission permanently denied"));
      _isTracking = false;
      return;
    }

    _positionStream?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position pos) async {
      final newLocation = LatLng(pos.latitude, pos.longitude);
      currentLocation = newLocation;

      safeEmit(MapCurrentLocationUpdated(newLocation));

      if (mapController != null && _isTracking) {
        await mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: newLocation,
              zoom: 17,
              tilt: 45,
              bearing: pos.heading,
            ),
          ),
        );
      }
    });
  }

  Future<void> stopLiveTracking() async {
    _isTracking = false;
    await _positionStream?.cancel();
    _statusTimer?.cancel();
    safeEmit(MapTrackingStopped());
  }

  bool get isTracking => _isTracking;

  @override
  Future<void> close() {
    _positionStream?.cancel();
    _statusTimer?.cancel();
    return super.close();
  }
}
