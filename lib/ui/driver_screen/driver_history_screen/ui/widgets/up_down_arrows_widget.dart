import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class UpDownArrowsWidget extends StatelessWidget {
  final double iconSize;

  const UpDownArrowsWidget({
    super.key,
    this.iconSize = 16, 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: Offset(0, -2.h),
          child: Transform.rotate(
            angle: 0.5,
            child: Icon(
              Icons.arrow_upward_outlined,
              color: ColorPalette.moreGreen,
              size: iconSize.sp,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(-4.w, 0),
          child: Transform.rotate(
            angle: 0.5,
            child: Icon(
              Icons.arrow_downward,
              color: ColorPalette.moreRed,
              size: iconSize.sp,
            ),
          ),
        ),
      ],
    );
  }
}
