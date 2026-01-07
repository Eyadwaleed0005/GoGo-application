import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  final MapRepository repository;

  RouteCubit(this.repository) : super(RouteInitial());

  LatLng? fromPoint;
  LatLng? toPoint;

  List<LatLng>? routePoints;
  double? distanceKm;
  double? durationMin;

  /// 🟢 تحديد نقطة البداية
  void setFromPoint(LatLng? point) {
    fromPoint = point;
    if (isClosed) return;
    emit(RoutePointsSelected(fromPoint: fromPoint, toPoint: toPoint));
  }

  /// 🔵 تحديد نقطة النهاية
  void setToPoint(LatLng? point) {
    toPoint = point;
    if (isClosed) return;
    emit(RoutePointsSelected(fromPoint: fromPoint, toPoint: toPoint));
  }

  /// 🚗 تحميل المسار الحالي بين النقطتين
  Future<void> loadRoute() async {
    if (fromPoint == null || toPoint == null) return;
    if (isClosed) return;

    emit(RouteLoading());

    try {
      final result = await repository.getRoute(fromPoint!, toPoint!);

      if (isClosed) return;

      if (result != null) {
        routePoints = result.routePoints;
        distanceKm = result.distanceKm;
        durationMin = result.durationMin;

        await _saveRouteToPrefs(fromPoint!, toPoint!);

        if (isClosed) return;

        emit(RouteLoaded(
          result.routePoints,
          distanceKm: result.distanceKm,
          durationMin: result.durationMin,
        ));
      } else {
        emit(RouteError("لم يتم العثور على مسار"));
      }
    } catch (e) {
      if (isClosed) return;
      emit(RouteError("فشل تحميل المسار: $e"));
    }
  }

  Future<void> clearRoute({bool removeSaved = false}) async {
    fromPoint = null;
    toPoint = null;
    routePoints = null;
    distanceKm = null;
    durationMin = null;

    if (removeSaved) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPreferenceKeys.savedRoutesPoints);
    }

    if (isClosed) return;
    emit(RouteInitial());
  }

  /// 💾 حفظ المسار في SharedPreferences
  Future<void> _saveRouteToPrefs(LatLng from, LatLng to) async {
    final prefs = await SharedPreferences.getInstance();

    final routeString =
        "${from.latitude},${from.longitude}|${to.latitude},${to.longitude}";

    await prefs.setStringList(
      SharedPreferenceKeys.savedRoutesPoints,
      [routeString],
    );
  }

  /// 🔁 تحميل آخر مسار محفوظ
  Future<void> loadSavedRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final routes =
        prefs.getStringList(SharedPreferenceKeys.savedRoutesPoints) ?? [];

    if (routes.isEmpty) return;

    final parts = routes.first.split("|");
    if (parts.length != 2) return;

    final fromParts = parts[0].split(",");
    final toParts = parts[1].split(",");
    if (fromParts.length != 2 || toParts.length != 2) return;

    try {
      final from = LatLng(
        double.parse(fromParts[0]),
        double.parse(fromParts[1]),
      );
      final to = LatLng(
        double.parse(toParts[0]),
        double.parse(toParts[1]),
      );

      fromPoint = from;
      toPoint = to;

      // loadRoute فيه emit فمهم نكون لسه مش مقفولين
      if (isClosed) return;
      await loadRoute();
    } catch (_) {
      // لو parsing فشل، تجاهل
    }
  }
}
