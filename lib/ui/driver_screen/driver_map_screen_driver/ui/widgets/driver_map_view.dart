import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/core/style/app_color.dart';
import '../../data/model/ride_model.dart';

class DriverMapView extends StatefulWidget {
  final RideModel? ride;
  final bool isTripStarted;

  const DriverMapView({super.key, this.ride, required this.isTripStarted});

  @override
  State<DriverMapView> createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<DriverMapView> {
  GoogleMapController? _googleMapController;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<ServiceStatus>? _serviceStatusSub;

  bool _gpsEnabled = true;
  Set<Polyline> _polylines = {};
  LatLng? _currentPosition;
  double _currentBearing = 0.0;

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

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    if (_gpsEnabled) {
      _startPositionStream();
    }
    _drawRoute();
  }

  /// 🔹 دالة تحسب الزوم المناسب حسب سرعة السائق
  double _getDynamicZoom(double speed) {
    if (speed < 10) return 17.0; // بطيء -> قريب
    if (speed < 30) return 16.5;
    if (speed < 60) return 16.0;
    return 15.5; // سريع -> الكاميرا تبعد أكتر
  }

  /// 🎯 تتبع موقع السواق وتحريك الكاميرا فوق العلامة الزرقاء
  void _startPositionStream() async {
    _positionStream?.cancel();

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 2,
          ),
        ).listen((pos) async {
          _currentPosition = LatLng(pos.latitude, pos.longitude);
          _currentBearing = _smoothBearing(_currentBearing, pos.heading);

          if (_googleMapController != null && _currentPosition != null) {
            try {
              await _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _currentPosition!,
                    zoom: _getDynamicZoom(pos.speed), // 👈 زوم ديناميكي حسب السرعة
                    bearing: _currentBearing,
                    tilt: 0,
                  ),
                ),
              );
              setState(() {});
            } catch (_) {}
          }
        });
  }

  /// 🌀 تنعيم دوران الكاميرا علشان ما تلفش فجأة
  double _smoothBearing(double oldBearing, double newBearing) {
    double diff = newBearing - oldBearing;
    if (diff.abs() > 180) {
      diff = diff > 0 ? diff - 360 : diff + 360;
    }
    return (oldBearing + diff * 0.1) % 360;
  }

  void _drawRoute() {
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

    setState(() {
      _polylines = {polyline};
    });
  }

  @override
  void didUpdateWidget(covariant DriverMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ride != widget.ride ||
        oldWidget.isTripStarted != widget.isTripStarted) {
      _drawRoute();
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
    final markers = <Marker>{};

    if (widget.ride?.routeGeometry?.isNotEmpty ?? false) {
      final endLatLng = LatLng(
        widget.ride!.routeGeometry!.last[1],
        widget.ride!.routeGeometry!.last[0],
      );

      markers.add(
        Marker(
          markerId: const MarkerId('end_point'),
          position: endLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'نقطة الوصول'),
        ),
      );
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      mapType: MapType.normal,
      initialCameraPosition: const CameraPosition(
        target: LatLng(31.1316, 33.7984),
        zoom: 16, // 👈 زوم مبدئي متوسط مناسب للسائق
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: false,
      trafficEnabled: true,
      buildingsEnabled: true,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      polylines: _polylines,
      markers: markers,
    );
  }
}
