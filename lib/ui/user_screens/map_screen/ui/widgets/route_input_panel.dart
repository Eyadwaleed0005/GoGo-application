import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/helper/map_helper.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_state.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_search_field.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/RideRequestScreen.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';

class RouteInputPanel extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;

  RouteInputPanel({
    super.key,
    required this.fromController,
    required this.toController,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.r,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BlocBuilder<RouteCubit, RouteState>(
          builder: (context, state) {
            final routeCubit = context.read<RouteCubit>();

            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocationSearchField(
                    label: "from".tr(),
                    controller: fromController,
                    isFromField: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "please_select_start".tr();
                      }
                      return null;
                    },
                    onSelected: (MapSuggestion suggestion) {
                      routeCubit.setFromPoint(suggestion.point);

                      final mapCubit = context.read<MapCubit>();
                      mapCubit.moveCamera(suggestion.point);
                      mapCubit.showPinAt(suggestion.point, suggestion.name);
                    },
                  ),
                  verticalSpace(8),
                  LocationSearchField(
                    label: "to".tr(),
                    controller: toController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "please_select_destination".tr();
                      }
                      return null;
                    },
                    onSelected: (MapSuggestion suggestion) {
                      routeCubit.setToPoint(suggestion.point);
                    },
                  ),
                  verticalSpace(8),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: state is RouteLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: ColorPalette.mainColor,
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.mainColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final from = routeCubit.fromPoint;
                              final to = routeCubit.toPoint;

                              if (from != null && to != null) {
                                try {
                                  await routeCubit.loadRouteIfReady();
                                  final currentState = routeCubit.state;

                                  if (currentState is RouteLoaded) {
                                    final adjustedFromName =
                                        await MapHelper.getNearestKnownAddress(from) ??
                                            fromController.text;
                                    final adjustedToName =
                                        await MapHelper.getNearestKnownAddress(to) ??
                                            toController.text;

                                    final prefs = await SharedPreferences.getInstance();
                                    final List<String> savedRoutes =
                                        prefs.getStringList(SharedPreferenceKeys.savedRoutes) ?? [];
                                    savedRoutes.add("$adjustedFromName → $adjustedToName");
                                    await prefs.setStringList(
                                        SharedPreferenceKeys.savedRoutes, savedRoutes);

                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RideRequestScreen(
                                          from: adjustedFromName,
                                          to: adjustedToName,
                                          fromLatLng: from,
                                          toLatLng: to,
                                          distanceKm: currentState.distanceKm,
                                          durationMin: currentState.durationMin,
                                        ),
                                      ),
                                    );
                                  } else if (currentState is RouteError) {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      CustomSnackBar.error(
                                          message: currentState.message),
                                    );
                                  }
                                } catch (e) {
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.error(message: e.toString()),
                                  );
                                }
                              } else {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                      message: "please_select_valid_locations".tr()),
                                );
                              }
                            },
                            child: Text(
                              "make_car_order".tr(),
                              style: TextStyles.font11blackSemiBold(),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
