import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class ConnectionStatusBar extends StatefulWidget {
  const ConnectionStatusBar({super.key});

  @override
  State<ConnectionStatusBar> createState() => _ConnectionStatusBarState();
}

class _ConnectionStatusBarState extends State<ConnectionStatusBar> {
  bool _noInternet = false;
  bool _noLocation = false;

  StreamSubscription<ConnectivityResult>? _connectivitySub;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkStatus();

    _connectivitySub = Connectivity().onConnectivityChanged
        .map((list) => list.isNotEmpty ? list.first : ConnectivityResult.none)
        .listen((result) {
          setState(() {
            _noInternet = result == ConnectivityResult.none;
          });
        });
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (_noLocation != !locationEnabled) {
        setState(() {
          _noLocation = !locationEnabled;
        });
      }
    });
  }

  Future<void> _checkStatus() async {
    final connectivity = await Connectivity().checkConnectivity();
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _noInternet = connectivity == ConnectivityResult.none;
      _noLocation = !locationEnabled;
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_noInternet && !_noLocation) return const SizedBox.shrink();
    String message = "";

    if (_noInternet && _noLocation) {
      message = 'warning_internet_location'.tr();
    } else if (_noInternet) {
      message = 'warning_internet'.tr();
    } else if (_noLocation) {
      message = 'warning_location'.tr();
    }
    return Container(
      width: double.infinity,
      color: ColorPalette.red,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: SafeArea(
        bottom: false,
        child: Text(
          message,
          style: TextStyles.font10whitebold(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
