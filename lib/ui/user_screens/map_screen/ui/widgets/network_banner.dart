import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class NetworkBanner extends StatefulWidget {
  const NetworkBanner({Key? key}) : super(key: key);

  @override
  State<NetworkBanner> createState() => _NetworkBannerState();
}

class _NetworkBannerState extends State<NetworkBanner> {
  bool isOffline = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startChecking();
  }

  void _startChecking() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      bool offline = false;

      // 🔹 Check network connection (Wi-Fi / Mobile Data)
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        offline = true;
      } else {
        // 🔹 Check actual internet access
        try {
          final stopwatch = Stopwatch()..start();
          final result = await http
              .get(Uri.parse("https://www.google.com"))
              .timeout(const Duration(seconds: 3));
          stopwatch.stop();

          if (result.statusCode != 200 || stopwatch.elapsedMilliseconds > 2000) {
            offline = true;
          }
        } catch (_) {
          offline = true;
        }
      }

      if (mounted && offline != isOffline) {
        setState(() => isOffline = offline);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        elevation: 6,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          color: ColorPalette.starsBorder,
          child: Text(
            "no_internet_warning".tr(),
            style: TextStyles.font10Blackbold().copyWith(
              color: Colors.white,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
