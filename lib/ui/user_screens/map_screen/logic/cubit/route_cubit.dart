import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repository.dart';
import 'route_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';

class RouteCubit extends Cubit<RouteState> {
  final MapRepository repository;

  RouteCubit(this.repository) : super(RouteInitial());

  mb.Point? fromPoint;
  mb.Point? toPoint;

  List<mb.Point>? savedRoutePoints;
  double? savedDistance;
  double? savedDuration;

  void setFromPoint(mb.Point? point) {
    fromPoint = point;
    emit(RoutePointsSelected(fromPoint: fromPoint, toPoint: toPoint));
  }

  void setToPoint(mb.Point? point) {
    toPoint = point;
    emit(RoutePointsSelected(fromPoint: fromPoint, toPoint: toPoint));
  }

  /// تحميل المسار الحالي فقط (بدون إعادة المسار القديم)
  Future<void> loadRouteIfReady() async {
    if (fromPoint == null || toPoint == null) return;

    emit(RouteLoading());

    try {
      final result = await repository.getRoute(fromPoint!, toPoint!);

      if (result != null) {
        savedRoutePoints = result.routePoints;
        savedDistance = result.distanceKm;
        savedDuration = result.durationMin;

        // ✅ استبدل المسار القديم بالجديد
        await _saveRouteToPrefs(fromPoint!, toPoint!);

        emit(RouteLoaded(
          result.routePoints,
          distanceKm: result.distanceKm,
          durationMin: result.durationMin,
        ));
      } else {
        emit(RouteError("لم يتم العثور على مسار"));
      }
    } catch (e) {
      emit(RouteError("فشل تحميل المسار: $e"));
    }
  }

  /// مسح البيانات
  void clearRoute({bool force = false}) async {
    fromPoint = null;
    toPoint = null;
    savedRoutePoints = null;
    savedDistance = null;
    savedDuration = null;

    if (force) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPreferenceKeys.savedRoutesPoints);
    }

    emit(RouteInitial());
  }

  /// حفظ المسار الجديد واستبدال القديم
  Future<void> _saveRouteToPrefs(mb.Point from, mb.Point to) async {
    final prefs = await SharedPreferences.getInstance();

    final routeString =
        "${from.coordinates.lng},${from.coordinates.lat}|${to.coordinates.lng},${to.coordinates.lat}";

    // ✅ نخزن مسار واحد فقط (نستبدل القديم بالجديد)
    await prefs.setStringList(
      SharedPreferenceKeys.savedRoutesPoints,
      [routeString],
    );
  }

  /// تحميل آخر مسار محفوظ
  Future<void> loadSavedRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final routes =
        prefs.getStringList(SharedPreferenceKeys.savedRoutesPoints) ?? [];

    if (routes.isEmpty) return;

    final parts = routes.first.split("|");
    if (parts.length == 2) {
      final fromParts = parts[0].split(",");
      final toParts = parts[1].split(",");

      if (fromParts.length == 2 && toParts.length == 2) {
        final from = mb.Point(
          coordinates: mb.Position(
            double.parse(fromParts[0]),
            double.parse(fromParts[1]),
          ),
        );
        final to = mb.Point(
          coordinates: mb.Position(
            double.parse(toParts[0]),
            double.parse(toParts[1]),
          ),
        );

        fromPoint = from;
        toPoint = to;

        try {
          final result = await repository.getRoute(from, to);
          if (result != null) {
            emit(RouteLoaded(
              result.routePoints,
              distanceKm: result.distanceKm,
              durationMin: result.durationMin,
            ));
          }
        } catch (_) {}
      }
    }
  }
}
