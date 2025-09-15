import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverInformationTextField extends StatelessWidget {
  final String title;
  final String value;

  const DriverInformationTextField({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.font12Blackbold(),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: ColorPalette.backgroundColor,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: ColorPalette.fieldStroke),
          ),
          child: Text(
            value.isNotEmpty ? value : "...",
            style: TextStyles.font10Blackbold(),
          ),
        ),
      ],
    );
  }
}
