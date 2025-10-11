import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/request_screen/logic/cubit/ride_request_screen_cubit.dart';

class TripCategoryDropdown extends StatelessWidget {
  const TripCategoryDropdown({super.key});

  OutlineInputBorder _borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: ColorPalette.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideRequestScreenCubit, RideRequestScreenState>(
      builder: (context, state) {
        final cubit = context.read<RideRequestScreenCubit>();

        List<Map<String, String>> items = [];
        if (state.carType == "car") {
          items = [
            {"value": "lone_trip", "label": "lone_trip".tr()},
            {"value": "delivery", "label": "delivery".tr()},
          ];
        } else if (state.carType == "scooter") {
          items = [
            {"value": "lone_trip", "label": "lone_trip".tr()},
            {"value": "delivery", "label": "delivery".tr()},
          ];
        } else {
          items = [
            {"value": "one_of_group", "label": "one_of_group".tr()},
            {"value": "two_of_group", "label": "two_of_group".tr()},
            {"value": "three_of_group", "label": "three_of_group".tr()},
            {"value": "lone_trip", "label": "lone_trip".tr()},
            {"value": "delivery", "label": "delivery".tr()},
          ];
        }

        String currentValue = items.any((e) => e["value"] == state.tripType)
            ? state.tripType
            : items.first["value"]!;

        return DropdownButtonFormField<String>(
          value: currentValue,
          isExpanded: true,
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            labelText: "trip_type".tr(),
            labelStyle: TextStyles.font10Blackbold().copyWith(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: _borderStyle(),
            enabledBorder: _borderStyle(),
            focusedBorder: _borderStyle(),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item["value"],
              child: Text(
                item["label"]!,
                style: TextStyles.font11Blackbold(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              cubit.changeTripType(value);
              if (value == "delivery") {
                cubit.changePassengers("0");
              } else if (cubit.state.passengers == "0") {
                cubit.changePassengers("");
              }
            }
          },
        );
      },
    );
  }
}
