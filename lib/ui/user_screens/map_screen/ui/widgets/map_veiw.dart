import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/user_drivers_socket_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/user_drivers_socket_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_cubit/location_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_cubit/location_state.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit/location_service_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit/location_service_state.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit/map_state.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit/route_state.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/driver_markers_overlay.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/pin_widget.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/trip_summary_card.dart';

class MapView extends StatefulWidget {
  final TextEditingController fromController;
  final bool isSelecting;
  final void Function(MapSuggestion)? onPlacePicked;
  final bool isTripApproved;

  const MapView({
    super.key,
    required this.fromController,
    this.isSelecting = false,
    this.onPlacePicked,
    this.isTripApproved = false,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Timer? _debounce;
  bool _firstCheckDone = false;
  bool isMapMoving = false;
  String placeName = "";
  Map<String, dynamic>? routeSummary;

  DateTime _lastCameraMove = DateTime.fromMillisecondsSinceEpoch(0);
  LatLng? _lastFollowPos;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
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
              listener: (context, state) async {
                if (state is LocationLoaded) {
                  await mapCubit.moveCamera(
                    state.currentLocation,
                    zoom: 17,
                    tilt: 30,
                    bearing: -15,
                  );
                }
              },
            ),
            BlocListener<RouteCubit, RouteState>(
              listener: (context, state) async {
                final routeCubit = context.read<RouteCubit>();

                if (routeCubit.routePoints != null &&
                    routeCubit.routePoints!.isNotEmpty) {
                  await mapCubit.drawRoute(routeCubit.routePoints!);
                  await mapCubit.fitCameraToBounds(
                    routeCubit.routePoints!.first,
                    routeCubit.routePoints!.last,
                  );

                  _safeSetState(() {
                    routeSummary = {
                      "distance": routeCubit.distanceKm ?? 0.0,
                      "timeText": routeCubit.durationMin != null
                          ? (routeCubit.durationMin! >= 60
                              ? "${(routeCubit.durationMin! / 60).toStringAsFixed(1)} h"
                              : "${routeCubit.durationMin!.toStringAsFixed(0)} min")
                          : "0 min",
                    };
                  });
                }

                if (state is RouteLoaded) {
                  await mapCubit.drawRoute(state.routePoints);
                  await mapCubit.fitCameraToBounds(
                    state.routePoints.first,
                    state.routePoints.last,
                  );

                  _safeSetState(() {
                    routeSummary = {
                      "distance": state.distanceKm,
                      "timeText": (state.durationMin >= 60
                          ? "${(state.durationMin / 60).toStringAsFixed(1)} h"
                          : "${state.durationMin.toStringAsFixed(0)} min"),
                    };
                  });
                }
              },
            ),
            BlocListener<LocationServiceCubit, LocationServiceState>(
              listener: (context, state) async {
                if (state is LocationServiceDisabled) {
                  if (!_firstCheckDone) {
                    await mapCubit.moveCamera(
                      const LatLng(30.0444, 31.2357),
                      zoom: 5,
                    );
                    _firstCheckDone = true;
                  }
                } else if (state is LocationServiceEnabled) {
                  _firstCheckDone = true;
                  try {
                    final pos = await Geolocator.getCurrentPosition();
                    await mapCubit.moveCamera(
                      LatLng(pos.latitude, pos.longitude),
                      zoom: 18,
                      tilt: 45,
                      bearing: -15,
                    );
                    context.read<LocationCubit>().getCurrentLocation();
                  } catch (_) {}
                }
              },
            ),
            BlocListener<UserDriversSocketCubit, UserDriversSocketState>(
              listener: (context, s) async {
                if (widget.isSelecting) return;
                if (!widget.isTripApproved) return;
                if (s is! UserDriversSocketDriversUpdated) return;
                if (s.followDriverId == null) return;
                if (s.drivers.isEmpty) return;

                final d = s.drivers.first;
                final pos = LatLng(d.lat, d.lng);

                final now = DateTime.now();
                if (now.difference(_lastCameraMove).inMilliseconds < 350) return;

                if (_lastFollowPos != null) {
                  final dx = (pos.latitude - _lastFollowPos!.latitude).abs();
                  final dy = (pos.longitude - _lastFollowPos!.longitude).abs();
                  if (dx < 0.00003 && dy < 0.00003) return;
                }

                _lastCameraMove = now;
                _lastFollowPos = pos;

                await mapCubit.moveCamera(
                  pos,
                  zoom: 17.5,
                  tilt: 45,
                  bearing: 0,
                );
              },
            ),
          ],
          child: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(30.0444, 31.2357),
                  zoom: 18,
                ),
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                onMapCreated: (controller) {
                  mapCubit.initMap(controller);
                },
                onCameraMoveStarted: () {
                  _safeSetState(() => isMapMoving = true);
                },
                onCameraIdle: () async {
                  _safeSetState(() => isMapMoving = false);

                  _debounce?.cancel();
                  _debounce = Timer(
                    const Duration(milliseconds: 500),
                    () async {
                      final screenSize = MediaQuery.of(context).size;
                      final center = await mapCubit.mapController?.getLatLng(
                        ScreenCoordinate(
                          x: (screenSize.width / 2).round(),
                          y: (screenSize.height / 2).round(),
                        ),
                      );

                      if (center != null) {
                        await mapCubit.getPlaceName(
                          center.latitude,
                          center.longitude,
                        );
                      }
                    },
                  );
                },
                markers: context.select((MapCubit c) {
                  final state = c.state;
                  final markers = <Marker>{};

                  markers.addAll(c.driverMarkers);

                  if (state is MapPinUpdated) {
                    markers.add(
                      Marker(
                        markerId: const MarkerId("selected"),
                        position: state.point,
                        infoWindow: InfoWindow(title: state.placeName),
                      ),
                    );
                  }

                  return markers;
                }),
                polylines: {
                  if (mapCubit.currentRoutePoints.isNotEmpty)
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: mapCubit.currentRoutePoints,
                      color: Colors.blueAccent,
                      width: 5,
                    ),
                },
              ),
              if (!widget.isSelecting) const DriverMarkersOverlay(),
              if (!widget.isTripApproved)
                AnimatedPinWidget(placeName: placeName, isMoving: isMapMoving),
              if (widget.isSelecting)
                Positioned(
                  bottom: 40.h,
                  left: 20.w,
                  right: 20.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final screenSize = MediaQuery.of(context).size;
                      final center = await mapCubit.mapController?.getLatLng(
                        ScreenCoordinate(
                          x: (screenSize.width / 2).round(),
                          y: (screenSize.height / 2).round(),
                        ),
                      );

                      if (center != null) {
                        final picked = MapSuggestion(
                          id: "manual_pick",
                          name: placeName.isNotEmpty
                              ? placeName
                              : "no_name_now".tr(),
                          latitude: center.latitude,
                          longitude: center.longitude,
                        );
                        widget.onPlacePicked?.call(picked);
                        Navigator.pop(context, picked);
                      }
                    },
                    child: Text(
                      "done".tr(),
                      style: const TextStyle(color: ColorPalette.textColor1),
                    ),
                  ),
                ),
              if (routeSummary != null)
                Positioned(
                  top: 45.h,
                  left: 20.w,
                  right: 20.w,
                  child: TripSummaryCard(
                    distanceKm: double.parse(
                      routeSummary!["distance"].toStringAsFixed(1),
                    ),
                    timeText: routeSummary!["timeText"],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
