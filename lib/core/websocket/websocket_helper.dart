import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'ws_logger.dart';

class WebSocketHelper {
  static WebSocketChannel? _channel;

  static String _baseUrl = "";
  static String _path = "";

  static bool _enableLogs = false;
  static late WsLogger _logger;

  static bool _autoReconnect = false;
  static Duration _reconnectDelay = const Duration(seconds: 2);
  static Timer? _reconnectTimer;

  static bool _isConnected = false;
  static bool get isConnected => _isConnected;

  static bool _isConnecting = false;
  static bool _manualClose = false;

  static final StreamController<Map<String, dynamic>> _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  static Stream<Map<String, dynamic>> get stream => _controller.stream;

  static void init({
    required String baseUrl,
    required String path,
    bool enableLogs = false,
    bool autoReconnect = false,
    Duration reconnectDelay = const Duration(seconds: 2),
  }) {
    _baseUrl = baseUrl;
    _path = path;
    _enableLogs = enableLogs;
    _autoReconnect = autoReconnect;
    _reconnectDelay = reconnectDelay;

    _logger = WsLogger(enabled: _enableLogs);
  }

  static Uri _uri() => Uri.parse("$_baseUrl$_path");

  static Future<Map<String, dynamic>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = <String, dynamic>{
      "Content-Type": "application/json",
    };

    if (token != null && token.isNotEmpty) {
      headers["Token"] = "Route__$token";
    }

    return headers;
  }

  static Future<void> connect() async {
    if (_isConnected || _isConnecting) return;

    _manualClose = false;
    _isConnecting = true;

    final uri = _uri();

    Map<String, dynamic> headers = const {};
    try {
      headers = await _buildHeaders();
    } catch (_) {
      headers = const {};
    }

    if (_enableLogs) {
      _logger.connect(uri.toString(), headers: headers);
    }

    try {
      final ch = IOWebSocketChannel.connect(uri, headers: headers);
      _channel = ch;

      // مهم: منع Unhandled Exception عبر catchError
      ch.ready.then((_) {
        _isConnected = true;
        _isConnecting = false;
        if (_enableLogs) _logger.connected();
      }).catchError((e, st) {
        _isConnected = false;
        _isConnecting = false;

        if (_enableLogs) _logger.error(e, st is StackTrace ? st : null);

        _safeCloseChannel();
        _scheduleReconnect("ready failed");
      });

      _channel!.stream.listen(
        (event) {
          if (_enableLogs) _logger.inMsg(event);
          final decoded = _decode(event);
          if (decoded != null) _controller.add(decoded);
        },
        onError: (e, st) {
          _isConnected = false;
          _isConnecting = false;

          if (_enableLogs) _logger.error(e, st is StackTrace ? st : null);

          _safeCloseChannel();
          _scheduleReconnect("onError");
        },
        onDone: () {
          _isConnected = false;
          _isConnecting = false;

          if (_enableLogs) _logger.disconnected(reason: "onDone");

          _safeCloseChannel();
          _scheduleReconnect("onDone");
        },
        cancelOnError: true,
      );
    } catch (e, st) {
      _isConnected = false;
      _isConnecting = false;

      if (_enableLogs) _logger.error(e, st);

      _safeCloseChannel();
      _scheduleReconnect("connect throw");
    }
  }

  static void send(dynamic payload) {
    if (_channel == null || !_isConnected) {
      if (_enableLogs) {
        _logger.disconnected(reason: "send skipped (not connected)");
      }
      return;
    }

    try {
      final text = payload is String ? payload : jsonEncode(payload);
      if (_enableLogs) _logger.out(payload);
      _channel!.sink.add(text);
    } catch (e, st) {
      _isConnected = false;

      if (_enableLogs) _logger.error(e, st);

      _safeCloseChannel();
      _scheduleReconnect("send failed");
    }
  }

  static Future<void> disconnect() async {
    _manualClose = true;

    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    if (_channel != null) {
      try {
        await _channel!.sink.close(status.normalClosure);
      } catch (_) {}
      _channel = null;
    }

    _isConnected = false;
    _isConnecting = false;

    if (_enableLogs) {
      _logger.disconnected(reason: "manual disconnect");
    }
  }

  static void _scheduleReconnect(String reason) {
    if (!_autoReconnect) return;
    if (_manualClose) return;
    if (_reconnectTimer != null) return;

    if (_enableLogs) {
      _logger.disconnected(reason: "reconnecting ($reason)");
    }

    _reconnectTimer = Timer(_reconnectDelay, () async {
      _reconnectTimer = null;
      if (_isConnected || _isConnecting || _manualClose) return;
      await connect();
    });
  }

  static void _safeCloseChannel() {
    try {
      _channel?.sink.close();
    } catch (_) {}
    _channel = null;
  }

  static Map<String, dynamic>? _decode(dynamic event) {
    if (event is! String) return null;
    try {
      final v = jsonDecode(event);
      return v is Map<String, dynamic> ? v : null;
    } catch (_) {
      return null;
    }
  }
}
