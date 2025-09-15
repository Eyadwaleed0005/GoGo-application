import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:gogo/core/api/end_points.dart';
import '../../data/model/ride_model.dart';

class DriverMapView extends StatefulWidget {
  final RideModel? ride;
  final bool isTripStarted;

  const DriverMapView({super.key, this.ride, required this.isTripStarted});

  @override
  State<DriverMapView> createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<DriverMapView> {
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PolylineAnnotationManager? _polylineManager;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<ServiceStatus>? _serviceStatusSub;

  bool _gpsEnabled = true;

  @override
  void initState() {
    super.initState();
    mapbox.MapboxOptions.setAccessToken(EndPoints.accessToken);
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

  Future<void> _onMapCreated(mapbox.MapboxMap controller) async {
    _mapboxMap = controller;
    await _mapboxMap!.location.updateSettings(
      mapbox.LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );

    _polylineManager ??= await _mapboxMap!.annotations
        .createPolylineAnnotationManager();
    _drawRoute();
    if (_gpsEnabled) {
      _startPositionStream();
    }
  }

  void _startPositionStream() async {
    _positionStream?.cancel();

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((pos) async {
          try {
            await _mapboxMap?.flyTo(
              mapbox.CameraOptions(
                center: mapbox.Point(
                  coordinates: mapbox.Position(pos.longitude, pos.latitude),
                ),
                zoom: 18,
                bearing: pos.heading,
              ),
              mapbox.MapAnimationOptions(duration: 1000),
            );
          } catch (e) {}
        }, onError: (err) {});
  }

  Future<void> _drawRoute() async {
    if (_polylineManager == null || widget.ride?.routeGeometry == null) return;
    await _polylineManager!.deleteAll();
    final coords = widget.ride!.routeGeometry!
        .map((p) => mapbox.Position(p[0], p[1]))
        .toList();
    await _polylineManager!.create(
      mapbox.PolylineAnnotationOptions(
        geometry: mapbox.LineString(coordinates: coords),
        lineColor: widget.isTripStarted
            ? ColorPalette.green.value
            : ColorPalette.mainColor.value,
        lineWidth: 5.0,
      ),
    );
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mapbox.MapWidget(
      styleUri: mapbox.MapboxStyles.MAPBOX_STREETS,
      cameraOptions: mapbox.CameraOptions(
        center: mapbox.Point(coordinates: mapbox.Position(33.7984, 31.1316)),
        zoom: 12,
      ),
      onMapCreated: _onMapCreated,
    );
  }
}
