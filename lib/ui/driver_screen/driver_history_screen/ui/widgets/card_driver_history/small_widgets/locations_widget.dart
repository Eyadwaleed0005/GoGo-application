import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class LocationsWidget extends StatelessWidget {
  final String firstLocation;
  final String secondLocation;

  const LocationsWidget({
    super.key,
    required this.firstLocation,
    required this.secondLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150.w,
          height: 30.h,
          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: ColorPalette.backgroundColor,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: ColorPalette.fieldStroke),
          ),
          child: Text(
            firstLocation,
            style: TextStyles.font10Blackbold(),
          ),
        ),
        verticalSpace(3),
        Container(
          width: 150.w,
          height: 30.h,
          padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: ColorPalette.textColor3,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: ColorPalette.fieldStroke),
          ),
          child: Text(
            secondLocation,
            style: TextStyles.font10Blackbold(),
          ),
        ),
      ],
    );
  }
}
