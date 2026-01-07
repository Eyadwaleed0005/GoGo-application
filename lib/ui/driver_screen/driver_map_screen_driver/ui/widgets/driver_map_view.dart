import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/core/style/app_color.dart';
import '../../data/model/ride_model.dart';

class DriverMapView extends StatefulWidget {
  final RideModel? ride;
  final bool isTripStarted;

  const DriverMapView({
    super.key,
    this.ride,
    required this.isTripStarted,
  });

  @override
  State<DriverMapView> createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<DriverMapView> {
  GoogleMapController? _googleMapController;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<ServiceStatus>? _serviceStatusSub;

  bool _gpsEnabled = true;

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  double _currentBearing = 0.0;

  // ✅ Fit يحصل مرة واحدة عند أول فتح + مرة واحدة عند تغيير المرحلة فقط
  bool _didFitInitially = false;

  // ✅ أول ما السواق يتحرك: نبدأ Follow (عشان ما نلخبطش مع fit)
  bool _followMode = false;

  // ✅ Throttle لحركة الكاميرا (تمنع الهزّة)
  DateTime _lastCameraUpdate = DateTime.fromMillisecondsSinceEpoch(0);

  // ✅ GPS Follow ثابت: لا zoom out
  static const double _gpsZoom = 18.5;
  static const double _gpsTilt = 70;
  static const double _forwardMeters = 120;

  @override
  void initState() {
    super.initState();
    _listenToGpsStatus();
  }

  void _listenToGpsStatus() {
    _serviceStatusSub = Geolocator.getServiceStatusStream().listen((status) {
      final enabled = status == ServiceStatus.enabled;
      if (_gpsEnabled != enabled) {
        setState(() => _gpsEnabled = enabled);

        if (enabled) {
          _startPositionStream();
        } else {
          _positionStream?.cancel();
          _positionStream = null;
        }
      }
    });
  }

  // ✅ نقطة قدّام السواق عشان يشوف الطريق اللي قدامه (GPS style)
  LatLng _offsetInMeters(LatLng from, double meters, double bearingDeg) {
    const double earthRadius = 6378137;

    final bearing = bearingDeg * (Math.pi / 180);
    final lat1 = from.latitude * (Math.pi / 180);
    final lng1 = from.longitude * (Math.pi / 180);
    final angDist = meters / earthRadius;

    final lat2 = Math.asin(
      Math.sin(lat1) * Math.cos(angDist) +
          Math.cos(lat1) * Math.sin(angDist) * Math.cos(bearing),
    );

    final lng2 = lng1 +
        Math.atan2(
          Math.sin(bearing) * Math.sin(angDist) * Math.cos(lat1),
          Math.cos(angDist) - Math.sin(lat1) * Math.sin(lat2),
        );

    return LatLng(lat2 * (180 / Math.pi), lng2 * (180 / Math.pi));
  }

  double _smoothBearing(double oldBearing, double newBearing) {
    double diff = newBearing - oldBearing;
    if (diff.abs() > 180) {
      diff = diff > 0 ? diff - 360 : diff + 360;
    }
    return (oldBearing + diff * 0.12) % 360;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _googleMapController = controller;

    _drawRoutePolylineOnly();

    // ✅ fit مرة واحدة عند أول فتح
    if (!_didFitInitially) {
      _didFitInitially = true;
      _fitRouteOnceIfAvailable();
    }

    if (_gpsEnabled) {
      _startPositionStream();
    }
  }

  void _fitRouteOnceIfAvailable() {
    if (_googleMapController == null) return;
    if (widget.ride?.routeGeometry == null || widget.ride!.routeGeometry!.isEmpty) return;

    final coords = widget.ride!.routeGeometry!
        .map((p) => LatLng(p[1], p[0]))
        .toList();

    _fitRouteBounds(coords);
  }

  void _startPositionStream() async {
    _positionStream?.cancel();

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2,
      ),
    ).listen((pos) async {
      if (_googleMapController == null) return;

      // ✅ نبدأ follow بس أول ما السواق يتحرك فعليًا (ده بيمنع “تروح وتيجي” مع fit)
      if (!_followMode && pos.speed > 1.5) {
        _followMode = true;
      }

      // لو لسه مبدأناش follow سيب الخريطة على fit (من غير تحريك مستمر)
      if (!_followMode) return;

      // ✅ تحديث bearing بس وهو بيتحرك
      _currentBearing = _smoothBearing(_currentBearing, pos.heading);

      // ✅ Throttle: تحديث كاميرا كل 600ms
      final now = DateTime.now();
      if (now.difference(_lastCameraUpdate).inMilliseconds < 600) return;
      _lastCameraUpdate = now;

      final me = LatLng(pos.latitude, pos.longitude);
      final target = _offsetInMeters(me, _forwardMeters, _currentBearing);

      try {
        await _googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: target,
              zoom: _gpsZoom,        // ✅ ثابت (مفيش zoom out)
              bearing: _currentBearing,
              tilt: _gpsTilt,        // ✅ من ورا زي GPS
            ),
          ),
        );
      } catch (_) {}
    });
  }

  Future<void> _fitRouteBounds(List<LatLng> points) async {
    if (_googleMapController == null || points.isEmpty) return;

    double minLat = points.first.latitude, maxLat = points.first.latitude;
    double minLng = points.first.longitude, maxLng = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      await _googleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 90),
      );
    } catch (_) {}
  }

  void _drawRoutePolylineOnly() {
    if (widget.ride?.routeGeometry == null) return;

    final coords = widget.ride!.routeGeometry!
        .map((p) => LatLng(p[1], p[0]))
        .toList();

    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: widget.isTripStarted ? ColorPalette.green : ColorPalette.moreBlue,
      width: 6,
      points: coords,
    );

    final markers = <Marker>{};
    if (coords.isNotEmpty) {
      markers.add(
        Marker(
          markerId: const MarkerId('target'),
          position: coords.last,
          infoWindow: const InfoWindow(title: 'الوجهة'),
        ),
      );
    }

    setState(() {
      _polylines = {polyline};
      _markers = markers;
    });
  }

  @override
  void didUpdateWidget(covariant DriverMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.ride != widget.ride ||
        oldWidget.isTripStarted != widget.isTripStarted) {
      _drawRoutePolylineOnly();
    }

    if (oldWidget.isTripStarted != widget.isTripStarted) {
      _followMode = false; 
      _fitRouteOnceIfAvailable();
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _serviceStatusSub?.cancel();
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      mapType: MapType.normal,

      initialCameraPosition: const CameraPosition(
        target: LatLng(31.1316, 33.7984),
        zoom: 16,
      ),

      myLocationEnabled: true,
      myLocationButtonEnabled: true,

      compassEnabled: false,
      trafficEnabled: true,
      buildingsEnabled: true,

      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,

      polylines: _polylines,
      markers: _markers,
    );
  }
}
