import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit/route_state.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';

part 'route_input_panel_state.dart';

class RouteInputPanelCubit extends Cubit<RouteInputPanelState> {
  final RouteCubit routeCubit;
  final MapCubit mapCubit;

  RouteInputPanelCubit({
    required this.routeCubit,
    required this.mapCubit,
  }) : super(RouteInputPanelInitial());

  void onFromSelected(MapSuggestion suggestion) {
    final point = LatLng(suggestion.latitude, suggestion.longitude);
    routeCubit.setFromPoint(point);
    mapCubit.moveCamera(point);
    mapCubit.showPinAt(point, suggestion.name);
  }

  void onToSelected(MapSuggestion suggestion) {
    final point = LatLng(suggestion.latitude, suggestion.longitude);
    routeCubit.setToPoint(point);
    mapCubit.showPinAt(point, suggestion.name);
  }

  Future<void> submitRoute({
    required BuildContext context,
    required TextEditingController fromController,
    required TextEditingController toController,
  }) async {
    final from = routeCubit.fromPoint;
    final to = routeCubit.toPoint;

    if (from == null || to == null) {
      emit(RouteInputPanelError("please_select_valid_locations.".tr()));
      return;
    }

    emit(RouteInputPanelLoading());

    try {
      await routeCubit.loadRoute();
      final currentState = routeCubit.state;

      if (currentState is RouteLoaded) {
        // ✅ نستخدم النصوص كما هي من المستخدم (الاقتراحات)
        final adjustedFromName = fromController.text;
        final adjustedToName = toController.text;

        // حفظ آخر مسار محليًا (اختياري)
        final prefs = await SharedPreferences.getInstance();
        final List<String> savedRoutes =
            prefs.getStringList(SharedPreferenceKeys.savedRoutes) ?? [];
        savedRoutes.add("$adjustedFromName → $adjustedToName");
        await prefs.setStringList(SharedPreferenceKeys.savedRoutes, savedRoutes);

        // رسم المسار على الخريطة
        await mapCubit.drawRoute(currentState.routePoints);
        await mapCubit.fitCameraToBounds(
          currentState.routePoints.first,
          currentState.routePoints.last,
        );

        // ✅ إرسال البيانات كما اختارها المستخدم
        emit(RouteInputPanelSuccess(
          from: adjustedFromName,
          to: adjustedToName,
          fromLatLng: from,
          toLatLng: to,
          distanceKm: currentState.distanceKm,
          durationMin: currentState.durationMin,
        ));
      } else if (currentState is RouteError) {
        emit(RouteInputPanelError(currentState.message));
      }
    } catch (e) {
      emit(RouteInputPanelError(e.toString()));
    }
  }
}
