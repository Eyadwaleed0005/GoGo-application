import 'package:gogo/core/websocket/websocket_helper.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/model/driver_location_post_dto.dart';

class DriverLocationSocketService {
  static void connectDriver(DriverLocationPostDto dto) {
    WebSocketHelper.send({
      "action": "ConnectDriver",
      "driverId": int.tryParse(dto.driverId) ?? dto.driverId,
      "latitude": dto.latitude,
      "longitude": dto.longitude,
    });
  }

  static void updateLocation(DriverLocationPostDto dto) {
    WebSocketHelper.send({
      "action": "UpdateLocation",
      "driverId": int.tryParse(dto.driverId) ?? dto.driverId,
      "location": {
        "lat": dto.latitude,
        "lng": dto.longitude,
        "timestamp": dto.timestamp.toUtc().toIso8601String(),
      }
    });
  }

  static void ping() {
    WebSocketHelper.send({"action": "Ping"});
  }
}
