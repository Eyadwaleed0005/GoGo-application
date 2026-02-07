import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class ChargeValueInput extends StatelessWidget {
  final TextEditingController controller;

  const ChargeValueInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "أدخل القيمة",
        hintStyle: TextStyles.font12Blackbold(),
        filled: true, 
        fillColor: ColorPalette.backgroundColor, 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      ),
    );
  }
}
