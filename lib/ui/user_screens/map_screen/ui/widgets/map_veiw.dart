import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_state.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_state.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_state.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/driver_markers_overlay.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/pin_widget.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/trip_summary_card.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' hide Position;

class MapView extends StatefulWidget {
  final TextEditingController fromController;
  final bool isSelecting;
  final void Function(MapSuggestion)? onPlacePicked;

  const MapView({
    super.key,
    required this.fromController,
    this.isSelecting = false,
    this.onPlacePicked,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Timer? _debounce;
  bool _firstCheckDone = false;
  bool isMapMoving = false;
  String placeName = "";
  Map<String, num>? routeSummary;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        if (state is MapPlaceSelected) {
          placeName = state.placeName;
        }

        return MultiBlocListener(
          listeners: [
            BlocListener<LocationCubit, LocationState>(
              listener: (context, state) {
                if (state is LocationLoaded) {
                  mapCubit.moveCamera(
                    state.currentLocation,
                    zoom: 17,
                    bearing: -15,
                    pitch: 30,
                  );
                }
              },
            ),
            BlocListener<RouteCubit, RouteState>(
              listener: (context, state) async {
                if (state is RouteLoaded) {
                  _debounce?.cancel();
                  _debounce = Timer(
                    const Duration(milliseconds: 100),
                    () async {
                      final from = state.routePoints.first;
                      final to = state.routePoints.last;
                      await mapCubit.drawRoute(state.routePoints);
                      await mapCubit.fitCameraToBounds(from, to);

                      final summary = await mapCubit.calculateDistanceAndTime(
                        from,
                        to,
                      );

                      print("📍 Summary from MapCubit: $summary");

                      setState(() {
                        routeSummary = summary;
                      });
                    },
                  );
                }
              },
            ),

            BlocListener<LocationServiceCubit, LocationServiceState>(
              listener: (context, state) async {
                if (state is LocationServiceDisabled) {
                  if (!_firstCheckDone) {
                    mapCubit.moveCamera(
                      Point(coordinates: Position(31.2357, 30.0444)),
                      zoom: 5,
                      bearing: 0,
                      pitch: 0,
                    );
                    _firstCheckDone = true;
                  }
                } else if (state is LocationServiceEnabled) {
                  _firstCheckDone = true;
                  try {
                    final pos = await Geolocator.getCurrentPosition();
                    final point = Point(
                      coordinates: Position(pos.longitude, pos.latitude),
                    );

                    await mapCubit.moveCamera(
                      point,
                      zoom: 14,
                      bearing: -15,
                      pitch: 30,
                    );
                    context.read<LocationCubit>().getCurrentLocation();
                  } catch (e) {
                    debugPrint("Error getting current location: $e");
                  }
                }
              },
            ),
          ],
          child: // داخل Stack:
Stack(
  alignment: Alignment.center,
  children: [
    // 🔹 الخريطة
    MapWidget(
      styleUri: "mapbox://styles/mapbox/streets-v12",
      cameraOptions: CameraOptions(zoom: 14.0),
      textureView: true,
      onMapCreated: (mapboxMap) async {
        debugPrint("🗺️ Map Created");

        await mapCubit.initMap(mapboxMap); // ✅ لازم await

        await mapboxMap.compass.updateSettings(
          CompassSettings(enabled: false),
        );
        await mapboxMap.scaleBar.updateSettings(
          ScaleBarSettings(enabled: false),
        );

        await mapboxMap.location.updateSettings(
          LocationComponentSettings(
            enabled: true,
            pulsingEnabled: true,
            puckBearingEnabled: true,
            showAccuracyRing: false,
          ),
        );
      },
      onCameraChangeListener: (event) async {
        if (!isMapMoving) setState(() => isMapMoving = true);

        _debounce?.cancel();
        _debounce = Timer(
          const Duration(milliseconds: 500),
          () async {
            if (mapCubit.mapboxMap == null) return;
            final cameraState = await mapCubit.mapboxMap!.getCameraState();
            final lat = cameraState.center.coordinates.lat.toDouble();
            final lng = cameraState.center.coordinates.lng.toDouble();

            debugPrint("📷 Camera moved to lat=$lat, lng=$lng");

            setState(() => isMapMoving = false);
            mapCubit.getPlaceName(lat, lng);
          },
        );
      },
    ),

    // 🔹 أيقونات السواقين
     DriverMarkersOverlay(), // ✅ خليتها const

    // 🔹 أيقونة المكان المختار (Pin)
    AnimatedPinWidget(placeName: placeName, isMoving: isMapMoving),

    // 🔹 زر الـ Done
    if (widget.isSelecting)
      Positioned(
        bottom: 40,
        left: 20,
        right: 20,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.mainColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text(
            "Done",
            style: TextStyle(color: ColorPalette.textColor1),
          ),
          onPressed: () async {
            final camera = await mapCubit.mapboxMap!.getCameraState();
            final picked = MapSuggestion(
              id: "manual_pick",
              name: placeName.isNotEmpty ? placeName : "No Name Now",
              latitude: camera.center.coordinates.lat.toDouble(),
              longitude: camera.center.coordinates.lng.toDouble(),
            );
            debugPrint("✅ Picked location: $picked");
            Navigator.pop(context, picked);
          },
        ),
      ),

    // 🔹 كارت ملخص الرحلة
    if (routeSummary != null)
      Positioned(
        top: 150,
        left: 20,
        right: 20,
        child: TripSummaryCard(
          distanceKm: (routeSummary!["distance"] ?? 0).toDouble(),
          durationMin: (routeSummary!["time"] ?? 0).toDouble(),
        ),
      ),
  ],
)
,
        );
      },
    );
  }
}
