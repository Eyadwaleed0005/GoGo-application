import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  final MapRepository repository;

  RouteCubit(this.repository) : super(RouteInitial());

  mb.Point? fromPoint;
  mb.Point? toPoint;

  /// 🔹 تحديد نقطة البداية
  void setFromPoint(mb.Point? point) {
    fromPoint = point;
    emit(RoutePointsSelected(fromPoint: fromPoint, toPoint: toPoint));
    _checkAndLoadRoute();
  }

  /// 🔹 تحديد نقطة النهاية
  void setToPoint(mb.Point? point) {
    toPoint = point;
    emit(RoutePointsSelected(fromPoint: fromPoint, toPoint: toPoint));
    _checkAndLoadRoute();
  }

  /// 🔹 تحميل المسار إذا كانت النقطتين متوفرتين
  void _checkAndLoadRoute() {
    if (fromPoint != null && toPoint != null) {
      getRoute(fromPoint!, toPoint!);
    }
  }

  /// 🛣 جلب المسار من الريبو
  Future<void> getRoute(mb.Point from, mb.Point to) async {
    emit(RouteLoading());
    try {
      final result = await repository.getRoute(from, to);

      if (result != null) {
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
}
