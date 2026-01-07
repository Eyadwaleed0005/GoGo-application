import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/confirmation_dialog.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/logic/cubit/driver_location_cubit.dart';

class DriverStatusButton extends StatefulWidget {
  const DriverStatusButton({super.key});

  @override
  State<DriverStatusButton> createState() => _DriverStatusButtonState();
}

class _DriverStatusButtonState extends State<DriverStatusButton>
    with WidgetsBindingObserver {
  bool isActive = false;
  String? driverId;
  bool locationEnabled = false;
  StreamSubscription<ServiceStatus>? _locationServiceSubscription;

  static const int heartbeatTimeoutMs = 120000; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocationService();
    _listenLocationChanges();
    _loadStatusAndDriverId();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationServiceSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      await _checkLocationService();
      await _loadStatusAndDriverId();
      if (isActive && driverId != null && locationEnabled) {
        context.read<DriverLocationCubit>().startTracking(driverId!);
      }
    }


    if (state == AppLifecycleState.detached) {
      if (isActive && driverId != null) {
        context.read<DriverLocationCubit>().stopTracking();
        await _saveStatus(false);
        if (mounted) {
          setState(() => isActive = false);
        }
      }
    }
  }

  Future<void> _loadStatusAndDriverId() async {
    final savedStatus = await SharedPreferencesHelper.getBool(
      key: SharedPreferenceKeys.driverActive,
    );

    final hb = await SharedPreferencesHelper.getInt(
      key: SharedPreferenceKeys.driverHeartbeatMs,
    );

    final id =
        await SecureStorageHelper.getdata(key: SecureStorageKeys.driverId);

    bool finalStatus = savedStatus ?? false;

    if (finalStatus) {
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final lastHb = hb ?? 0;
      final diff = nowMs - lastHb;

      if (lastHb == 0 || diff > heartbeatTimeoutMs) {
        finalStatus = false;
        await _saveStatus(false);
      }
    }

    if (!mounted) return;
    setState(() {
      isActive = finalStatus;
      driverId = id;
    });

    if (isActive && driverId != null && locationEnabled) {
      context.read<DriverLocationCubit>().startTracking(driverId!);
    }
  }

  Future<void> _checkLocationService() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;
    setState(() {
      locationEnabled = enabled;
      if (!enabled) isActive = false;
    });

    if (!enabled && driverId != null) {
      context.read<DriverLocationCubit>().stopTracking();
      await _saveStatus(false);
    }
  }

  void _listenLocationChanges() {
    _locationServiceSubscription =
        Geolocator.getServiceStatusStream().listen((status) async {
      final enabled = status == ServiceStatus.enabled;
      if (!mounted) return;

      setState(() {
        locationEnabled = enabled;
        if (!enabled) isActive = false;
      });

      if (!enabled && driverId != null) {
        context.read<DriverLocationCubit>().stopTracking();
        await _saveStatus(false);
      }
    });
  }

  Future<void> _saveStatus(bool value) async {
    await SharedPreferencesHelper.saveBool(
      key: SharedPreferenceKeys.driverActive,
      value: value,
    );
  }

  Future<void> _promptEnableLocation() async {
    await ConfirmationDialog.show(
      context: context,
      title: "enable_location".tr(),
      content: "enable_location_message".tr(),
      confirmText: "open_settings".tr(),
      showCancel: true,
      onConfirm: () async {
        await Geolocator.openLocationSettings();
        await _checkLocationService();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isActive ? "Active" : "Not Active",
          style: isActive
              ? TextStyles.font10greenSemiBold()
              : TextStyles.font10redSemiBold(),
        ),
        Switch(
          value: isActive,
          activeColor: ColorPalette.textColor3,
          inactiveThumbColor: ColorPalette.textColor3,
          activeTrackColor: ColorPalette.green,
          inactiveTrackColor: ColorPalette.red,
          onChanged: locationEnabled
              ? (value) async {
                  if (!mounted) return;

                  setState(() => isActive = value);
                  await _saveStatus(value);

                  if (driverId == null) return;

                  if (value) {
                    context.read<DriverLocationCubit>().startTracking(driverId!);
                  } else {
                    context.read<DriverLocationCubit>().stopTracking();
                  }
                }
              : (_) async {
                  await _promptEnableLocation();
                },
        ),
      ],
    );
  }
}
