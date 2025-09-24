import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart';

class CarInfoForm extends StatelessWidget {
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController colorController;
  final TextEditingController plateController;

  const CarInfoForm({
    super.key,
    required this.brandController,
    required this.modelController,
    required this.colorController,
    required this.plateController,
  });

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label.tr(),
      labelStyle: TextStyles.font10Blackbold(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorPalette.fieldStroke),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorPalette.mainColor, width: 2.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: brandController,
          decoration: _inputDecoration("car_brand"),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "enter_car_brand".tr();
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: modelController,
          decoration: _inputDecoration("car_model"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "enter_car_model".tr();
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: colorController,
          decoration: _inputDecoration("car_color"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "enter_car_color".tr();
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: plateController,
          decoration: _inputDecoration("plate_number"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "enter_plate_number".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
