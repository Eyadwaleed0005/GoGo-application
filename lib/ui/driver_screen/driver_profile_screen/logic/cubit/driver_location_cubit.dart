import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/core/websocket/websocket_helper.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/model/driver_location_post_dto.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/repo/driver_location_socket_service.dart';

part 'driver_location_state.dart';

class DriverLocationCubit extends Cubit<DriverLocationState> {
  StreamSubscription<Position>? _positionSub;
  Timer? _pingTimer;

  bool _trackingEnabled = false;
  bool _driverRegistered = false;

  DateTime _lastSent = DateTime.fromMillisecondsSinceEpoch(0);
  String? _driverId;

  DriverLocationCubit() : super(DriverLocationInitial());

  Future<void> startTracking(String driverId) async {
    _driverId = driverId;
    _trackingEnabled = true;
    _driverRegistered = false;
    _lastSent = DateTime.fromMillisecondsSinceEpoch(0);

    await _positionSub?.cancel();
    _positionSub = null;

    _pingTimer?.cancel();
    _pingTimer = null;

    WebSocketHelper.init(
      baseUrl: EndPoints.wsBaseUrl,
      path: EndPoints.wsLocationPath,
      enableLogs: true,
      autoReconnect: true,
    );

    emit(DriverLocationRunning());

    await _ensureConnected();
    await _saveHeartbeat();

    _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) async {
      if (!_trackingEnabled) return;
      if (!WebSocketHelper.isConnected) {
        await _ensureConnected();
      }
      if (WebSocketHelper.isConnected) {
        DriverLocationSocketService.ping();
        await _saveHeartbeat();
      }
    });

    final settings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSub = Geolocator.getPositionStream(locationSettings: settings).listen(
      (position) async {
        if (!_trackingEnabled) return;

        final now = DateTime.now();
        if (now.difference(_lastSent).inSeconds < 2) return;

        if (!WebSocketHelper.isConnected) {
          await _ensureConnected();
        }
        if (!WebSocketHelper.isConnected) return;

        final dto = DriverLocationPostDto(
          driverId: _driverId ?? driverId,
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: now,
          speed: position.speed,
          heading: position.heading,
          accuracy: position.accuracy,
        );

        if (!_driverRegistered) {
          DriverLocationSocketService.connectDriver(dto);
          _driverRegistered = true;
        }

        DriverLocationSocketService.updateLocation(dto);
        _lastSent = now;

        await _saveHeartbeat();
      },
      onError: (_) {},
      cancelOnError: false,
    );
  }

  Future<void> stopTracking() async {
    _trackingEnabled = false;
    _driverRegistered = false;

    _pingTimer?.cancel();
    _pingTimer = null;

    await _positionSub?.cancel();
    _positionSub = null;

    await WebSocketHelper.disconnect();
    if (!isClosed) emit(DriverLocationStopped());
  }

  Future<void> _ensureConnected() async {
    if (WebSocketHelper.isConnected) return;
    try {
      await WebSocketHelper.connect();
      _driverRegistered = false;
    } catch (_) {}
  }

  Future<void> _saveHeartbeat() async {
    await SharedPreferencesHelper.saveInt(
      key: SharedPreferenceKeys.driverHeartbeatMs,
      value: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> close() async {
    await stopTracking();
    return super.close();
  }
}
