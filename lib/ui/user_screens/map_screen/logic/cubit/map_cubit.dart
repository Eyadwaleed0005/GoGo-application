import 'dart:math' show sin, cos, atan2, sqrt, pi, min, max;
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final style = mapboxMap!.style;
    await style.removeStyleLayer("route_layer").catchError((_) {});
    await style.removeStyleSource("route_source").catchError((_) {});

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

    await style.addSource(mb.GeoJsonSource(id: "route_source", data: geoJson));
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
  }

  Future<void> drawStraightLine(mb.Point from, mb.Point to) async {
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
  }

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

  Future<Map<String, num>> calculateDistanceAndTime(
    mb.Point from,
    mb.Point to,
  ) async {
    const earthRadius = 6371; // نصف قطر الأرض بالكيلومتر

    double dLat = (to.coordinates.lat - from.coordinates.lat) * (pi / 180);
    double dLon = (to.coordinates.lng - from.coordinates.lng) * (pi / 180);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(from.coordinates.lat * (pi / 180)) *
            cos(to.coordinates.lat * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c; // المسافة بالكيلومتر

    double avgSpeed = 60; // متوسط السرعة كم/س
    double timeHours = distance / avgSpeed;
    double timeMinutes = timeHours * 60;

    return {
      "distance": double.parse(distance.toStringAsFixed(2)), // كم
      "time": double.parse(timeMinutes.toStringAsFixed(0)), // دقائق
      "direct_distance": distance, // مسافة مستقيمة (ممكن تعرضها أو لا)
    };
  }

  Future<void> getPlaceName(num lat, num lng) async {
    final place = await repo.getPlaceName(
      mb.Point(coordinates: mb.Position(lng.toDouble(), lat.toDouble())),
    );
    safeEmit(MapPlaceSelected(place));
  }

  void showPinAt(mb.Point point, String name) {}
}
