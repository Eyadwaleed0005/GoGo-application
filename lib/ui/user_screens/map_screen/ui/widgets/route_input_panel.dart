import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/map_helper.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_state.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_search_field.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/RideRequestScreen.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

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
                    label: "From",
                    controller: fromController,
                    isFromField: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please select the starting point";
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
                    label: "To",
                    controller: toController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please select the destination";
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.mainColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
        onPressed: () async {
  if (_formKey.currentState!.validate()) {
    final from = routeCubit.fromPoint;
    final to = routeCubit.toPoint;

    if (from != null && to != null) {
      final mapRepo = MapRepository();
      final routeData = await mapRepo.getRoute(from, to);

      if (routeData != null) {
        final distanceKm = routeData.distanceKm;
        final durationMin = routeData.durationMin;

        // 🔹 أقرب عنوان للنقطة "from"
        final adjustedFromName =
            await MapHelper.getNearestKnownAddress(from) ??
            fromController.text; // fallback لو فشل

        // 🔹 أقرب عنوان للنقطة "to"
        final adjustedToName =
            await MapHelper.getNearestKnownAddress(to) ??
            toController.text; // fallback لو فشل

        print("=== Ride Request Data ===");
print("From LatLng: ${from.coordinates[1]}, ${from.coordinates[0]}"); // lat, lng
print("To LatLng: ${to.coordinates[1]}, ${to.coordinates[0]}");     // lat, lng
print("Adjusted From Name: $adjustedFromName");
print("Adjusted To Name: $adjustedToName");
print("Distance (km): $distanceKm");
print("Duration (min): $durationMin");


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RideRequestScreen(
              from: adjustedFromName,
              to: adjustedToName,
              fromLatLng: from,
              toLatLng: to,
              distanceKm: distanceKm,
              durationMin: durationMin,
            ),
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Failed to get route info",
          ),
        );
      }
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Please select valid locations",
        ),
      );
    }
  }
}

,
                      child: Text(
                        "Make Car Order",
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
