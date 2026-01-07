import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/websocket/websocket_helper.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_places_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/user_drivers_socket_service.dart';
import 'user_drivers_socket_state.dart';

class UserDriversSocketCubit extends Cubit<UserDriversSocketState> {
  StreamSubscription<Map<String, dynamic>>? _sub;
  Timer? _pollTimer;

  final Map<int, DriverPlace> _cache = {};
  int? _followDriverId;
  bool _running = false;

  UserDriversSocketCubit() : super(UserDriversSocketInitial());

  Future<void> start({int? followDriverId}) async {
    _followDriverId = followDriverId;
    _running = true;

    await _sub?.cancel();
    _sub = null;

    _pollTimer?.cancel();
    _pollTimer = null;

    WebSocketHelper.init(
      baseUrl: EndPoints.wsBaseUrl,
      path: EndPoints.wsLocationPath,
      enableLogs: true,
      autoReconnect: true,
    );

    if (!isClosed) emit(UserDriversSocketConnecting());

    await _ensureConnected();

    _sub = WebSocketHelper.stream.listen((msg) {
      if (!_running || isClosed) return;
      _handleMessage(msg);
    });

    if (WebSocketHelper.isConnected) {
      UserDriversSocketService.connectClient();
      if (_followDriverId != null) {
        UserDriversSocketService.getDriverLocation(_followDriverId!);
      } else {
        UserDriversSocketService.getOnlineDrivers();
      }
    }

    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!_running || isClosed) return;

      if (!WebSocketHelper.isConnected) {
        await _ensureConnected();
      }

      if (!WebSocketHelper.isConnected) return;

      UserDriversSocketService.ping();

      if (_followDriverId != null) {
        UserDriversSocketService.getDriverLocation(_followDriverId!);
      } else {
        UserDriversSocketService.getOnlineDrivers();
      }
    });

    if (!isClosed) emit(UserDriversSocketConnected());
  }

  void setFollowDriver(int? driverId) {
    _followDriverId = driverId;
    _emitDrivers();
  }

  Future<void> stop() async {
    _running = false;

    _pollTimer?.cancel();
    _pollTimer = null;

    await _sub?.cancel();
    _sub = null;

    await WebSocketHelper.disconnect();
  }

  Future<void> _ensureConnected() async {
    if (WebSocketHelper.isConnected) return;
    try {
      await WebSocketHelper.connect();
      if (WebSocketHelper.isConnected) {
        UserDriversSocketService.connectClient();
      }
    } catch (_) {}
  }

  void _handleMessage(Map<String, dynamic> msg) {
    final action = (msg['action'] ?? '').toString();

    if (action == 'OnlineDrivers') {
      final list = _extractDriversList(msg['data']);
      for (final d in list) {
        _cache[d.driverId] = d;
      }
      _emitDrivers();
      return;
    }

    if (action == 'DriverLocation') {
      final d = _extractSingleDriver(msg['data']);
      if (d != null) {
        _cache[d.driverId] = d;
        _emitDrivers();
      }
      return;
    }

    if (action == 'LocationUpdate') {
      final d = _extractSingleDriver(msg['data'] ?? msg);
      if (d != null) {
        final prev = _cache[d.driverId];
        _cache[d.driverId] = prev == null
            ? d
            : prev.copyWith(
                lat: d.lat,
                lng: d.lng,
                lastUpdate: d.lastUpdate,
                isOnline: d.isOnline,
                driverName: d.driverName.isEmpty ? prev.driverName : d.driverName,
              );
        _emitDrivers();
      }
      return;
    }

    if (action == 'DriverConnected') {
      final d = _extractSingleDriver(msg['data']);
      if (d != null) {
        _cache[d.driverId] = d;
        _emitDrivers();
      }
      return;
    }
  }

  void _emitDrivers() {
    if (!_running || isClosed) return;

    List<DriverPlace> out;

    if (_followDriverId != null) {
      final d = _cache[_followDriverId!];
      out = d == null ? <DriverPlace>[] : <DriverPlace>[d];
    } else {
      out = _cache.values.toList()
        ..sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));
    }

    emit(UserDriversSocketDriversUpdated(out, _followDriverId));
  }

  List<DriverPlace> _extractDriversList(dynamic data) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map(DriverPlace.fromWs).toList();
    }

    if (data is Map<String, dynamic>) {
      final values = data['\$values'];
      if (values is List) {
        return values.whereType<Map<String, dynamic>>().map(DriverPlace.fromWs).toList();
      }
    }

    return const <DriverPlace>[];
  }

  DriverPlace? _extractSingleDriver(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('location') && data['location'] is Map<String, dynamic>) {
        final loc = data['location'] as Map<String, dynamic>;
        final merged = <String, dynamic>{...data, ...loc};
        return DriverPlace.fromWs(merged);
      }
      return DriverPlace.fromWs(data);
    }
    return null;
  }

  @override
  Future<void> close() async {
    await stop();
    return super.close();
  }
}
