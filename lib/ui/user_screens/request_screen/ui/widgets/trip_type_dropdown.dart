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
    final items = [
      {"value": "one_of_group", "label": "one_of_group".tr()},
      {"value": "two_of_group", "label": "two_of_group".tr()},
      {"value": "three_of_group", "label": "three_of_group".tr()},
      {"value": "lone_trip", "label": "lone_trip".tr()},
      {"value": "delivery", "label": "delivery".tr()},
    ];

    return BlocBuilder<RideRequestScreenCubit, RideRequestScreenState>(
      builder: (context, state) {
        final cubit = context.read<RideRequestScreenCubit>();
        final currentValue = state.tripType;

        return DropdownButtonFormField<String>(
          value: currentValue,
          isExpanded: true,
          dropdownColor: Colors.white,
          menuMaxHeight: 250.h,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            filled: true,
            fillColor: ColorPalette.backgroundColor,
            border: _borderStyle(),
            enabledBorder: _borderStyle(),
            focusedBorder: _borderStyle(),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item["value"],
              child: Center(
                child: Text(
                  item["label"]!,
                  style: TextStyles.font10Blackbold(),
                ),
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
