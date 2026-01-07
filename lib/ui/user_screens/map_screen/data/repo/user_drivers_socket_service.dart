import 'package:gogo/core/websocket/websocket_helper.dart';

class UserDriversSocketService {
  static void connectClient() {
    WebSocketHelper.send({"action": "ConnectClient"});
  }

  static void getOnlineDrivers() {
    WebSocketHelper.send({"action": "GetOnlineDrivers"});
  }

  static void getDriverLocation(int driverId) {
    WebSocketHelper.send({"action": "GetDriverLocation", "driverId": driverId});
  }

  static void ping() {
    WebSocketHelper.send({"action": "Ping"});
  }
}
