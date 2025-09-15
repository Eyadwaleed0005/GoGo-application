import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';


class LocationFieldsWidget extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final bool fromHasCoords;
  final bool toHasCoords;

  const LocationFieldsWidget({
    super.key,
    required this.fromController,
    required this.toController,
    required this.fromHasCoords,
    required this.toHasCoords,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: fromController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "From",
            hintStyle: TextStyles.font15Blackbold(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: ColorPalette.fieldStroke, width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: ColorPalette.mainColor, width: 1.5.w),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color: fromHasCoords
                      ? ColorPalette.mainColor
                      : ColorPalette.buttons,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorPalette.fieldStroke, width: 1.w),
                ),
              ),
            ),
          ),
        ),
        verticalSpace(12),
        TextFormField(
          controller: toController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "To",
            hintStyle: TextStyles.font15Blackbold(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: ColorPalette.fieldStroke, width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: ColorPalette.mainColor, width: 1.5.w),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color: toHasCoords
                      ? ColorPalette.mainColor
                      : ColorPalette.buttons,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorPalette.fieldStroke, width: 1.w),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
