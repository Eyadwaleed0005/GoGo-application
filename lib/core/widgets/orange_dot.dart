import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class OrangeDot extends StatelessWidget {
  const OrangeDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      height: 10.h,
      decoration: const BoxDecoration(
        color: ColorPalette.mainColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
