import 'dart:convert';

class WsLogger {
  final bool enabled;

  WsLogger({required this.enabled});

  String _ts() => DateTime.now().toIso8601String();

  void connect(String url, {Map<String, dynamic>? headers}) {
    if (!enabled) return;

    _box(
      title: "WS CONNECT",
      body: {
        "url": url,
        if (headers != null) "headers": headers,
      },
    );
  }

  void connected() {
    if (!enabled) return;
    print("[${_ts()}] WS CONNECTED");
  }

  void disconnected({required String reason}) {
    if (!enabled) return;

    _box(
      title: "WS DISCONNECTED",
      body: {"reason": reason},
    );
  }

  void out(dynamic payload) {
    if (!enabled) return;

    dynamic body = payload;
    if (payload is String) {
      body = {"raw": payload, "json": _tryJson(payload)};
    }

    _box(
      title: "WS OUT",
      body: body,
    );
  }

  void inMsg(dynamic event) {
    if (!enabled) return;

    final raw = event is String ? event : event.toString();
    _box(
      title: "WS IN",
      body: {
        "raw": raw,
        "json": _tryJson(raw),
      },
    );
  }

  void error(dynamic error, [StackTrace? st]) {
    if (!enabled) return;

    _box(
      title: "WS ERROR",
      body: {
        "error": error.toString(),
        "stack": st?.toString() ?? "",
      },
    );
  }

  dynamic _tryJson(String raw) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  void _box({required String title, required dynamic body}) {
    final t = _ts();
    print("[$t] ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────");
    print("[$t] │ $title");
    final pretty = _pretty(body);
    for (final line in pretty.split('\n')) {
      print("[$t] │ $line");
    }
    print("[$t] └────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────");
  }

  String _pretty(dynamic v) {
    try {
      const encoder = JsonEncoder.withIndent("  ");
      return encoder.convert(v);
    } catch (_) {
      return v.toString();
    }
  }
}
