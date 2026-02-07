import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class LocationErrorWidget extends StatelessWidget {
  const LocationErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 50.h,
        color: ColorPalette.starsBorder,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(
          "unable_to_detect_location".tr(),
          style: TextStyles.font10Blackbold().copyWith(
            color: ColorPalette.textColor3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
