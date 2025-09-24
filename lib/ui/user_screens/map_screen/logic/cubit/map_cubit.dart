import 'dart:math' show min, max;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_ride_repository.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

import 'map_state.dart';
import '../../data/repo/map_repository.dart';

class MapCubit extends Cubit<MapState> {
  mb.MapboxMap? mapboxMap;
  mb.PointAnnotationManager? driverAnnotationManager;
  final MapRepository repo;

  MapCubit(this.repo) : super(MapInitial());

  void safeEmit(MapState state) {
    if (!isClosed) emit(state);
  }

  Future<void> initMap(mb.MapboxMap map) async {
    mapboxMap = map;

    driverAnnotationManager = await mapboxMap!.annotations
        .createPointAnnotationManager();

    safeEmit(MapReady(map));
  }

  Future<void> moveCamera(
    mb.Point point, {
    double zoom = 16,
    double bearing = 0,
    double pitch = 0,
  }) async {
    if (mapboxMap == null) return;
    await mapboxMap!.setCamera(
      mb.CameraOptions(
        center: point,
        zoom: zoom,
        bearing: bearing,
        pitch: pitch,
      ),
    );
    safeEmit(MapMoved(point));
  }

  Future<void> drawRoute(List<mb.Point> points) async {
    if (mapboxMap == null || points.isEmpty) return;

    try {
      final style = mapboxMap!.style;

      if (await style.styleLayerExists("route_layer")) {
        await style.removeStyleLayer("route_layer");
      }
      if (await style.styleSourceExists("route_source")) {
        await style.removeStyleSource("route_source");
      }

      final coords = points
          .map((p) => [p.coordinates.lng, p.coordinates.lat])
          .toList();

      final geoJson =
          '''
    {
      "type": "FeatureCollection",
      "features": [
        { "type": "Feature","geometry": {"type": "LineString","coordinates": $coords}}
      ]
    }
    ''';

      await style.addSource(
        mb.GeoJsonSource(id: "route_source", data: geoJson),
      );

      await style.addLayer(
        mb.LineLayer(
          id: "route_layer",
          sourceId: "route_source",
          lineColor: 0xFF0066FF,
          lineWidth: 6.0,
          lineJoin: mb.LineJoin.ROUND,
          lineCap: mb.LineCap.ROUND,
        ),
      );

      safeEmit(MapRouteDrawn(points));
    } catch (e) {}
  }
  /*Future<void> drawStraightLine(mb.Point from, mb.Point to) async {
    if (mapboxMap == null) return;
    final style = mapboxMap!.style;
    await style.removeStyleLayer("straight_line_layer").catchError((_) {});
    await style.removeStyleSource("straight_line_source").catchError((_) {});

    final coords = [
      [from.coordinates.lng, from.coordinates.lat],
      [to.coordinates.lng, to.coordinates.lat],
    ];

    final geoJson =
        '''
{
  "type": "FeatureCollection",
  "features": [
    { "type": "Feature","geometry": {"type": "LineString","coordinates": $coords}}
  ]
}
''';

    await style.addSource(
      mb.GeoJsonSource(id: "straight_line_source", data: geoJson),
    );
    await style.addLayer(
      mb.LineLayer(
        id: "straight_line_layer",
        sourceId: "straight_line_source",
        lineColor: 0xFF00AA00,
        lineWidth: 4.0,
        lineJoin: mb.LineJoin.ROUND,
        lineCap: mb.LineCap.ROUND,
      ),
    );
  }*/

  Future<void> fitCameraToBounds(mb.Point from, mb.Point to) async {
    if (mapboxMap == null) return;

    final bounds = mb.CoordinateBounds(
      southwest: mb.Point(
        coordinates: mb.Position(
          min(from.coordinates.lng, to.coordinates.lng),
          min(from.coordinates.lat, to.coordinates.lat),
        ),
      ),
      northeast: mb.Point(
        coordinates: mb.Position(
          max(from.coordinates.lng, to.coordinates.lng),
          max(from.coordinates.lat, to.coordinates.lat),
        ),
      ),
      infiniteBounds: false,
    );

    final cameraOptions = await mapboxMap!.cameraForCoordinateBounds(
      bounds,
      mb.MbxEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
      null,
      null,
      null,
      null,
    );

    await mapboxMap!.flyTo(cameraOptions, null);
  }

  Future<Map<String, dynamic>> calculateDistanceAndTime(
    mb.Point from,
    mb.Point to,
  ) async {
    final repo = DriverRideRepository();

    try {
      final ride = await repo.getRoute(
        fromLat: from.coordinates.lat.toDouble(),
        fromLng: from.coordinates.lng.toDouble(),
        toLat: to.coordinates.lat.toDouble(),
        toLng: to.coordinates.lng.toDouble(),
        userPhone: "",
      );

      final distanceKm = ride.distanceKm ?? 0.0;
      final durationMin = ride.durationMin ?? 0.0;

      final timeText = durationMin >= 60
          ? "${(durationMin / 60).toStringAsFixed(1)} h"
          : "${durationMin.toStringAsFixed(0)} min";

      return {
        "distance": distanceKm,
        "timeText": timeText, // دايمًا نص جاهز للعرض
        "durationMin": durationMin, // القيمة الأصلية
      };
    } catch (e) {
      print("Error calculating distance and time: $e");
      return {"distance": 0.0, "timeText": "0 min", "durationMin": 0.0};
    }
  }

  Future<void> getPlaceName(num lat, num lng) async {
    final place = await repo.getPlaceName(
      mb.Point(coordinates: mb.Position(lng.toDouble(), lat.toDouble())),
    );
    safeEmit(MapPlaceSelected(place));
  }

  void showPinAt(mb.Point point, String name) {}
}
