import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class TripPriceWidget extends StatelessWidget {
  final String price;

  const TripPriceWidget({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: ColorPalette.backgroundColor,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: ColorPalette.fieldStroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            price,
            style: TextStyles.font10Blackbold(),
          ),
          horizontalSpace(4),
          Text(
            "EGP", 
            style: TextStyles.font10Blackbold(),
          ),
        ],
      ),
    );
  }
}
