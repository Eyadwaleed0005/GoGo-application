import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

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
      labelText: label,
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
          decoration: _inputDecoration("Car Brand"),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter the car brand";
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: modelController,
          decoration: _inputDecoration("Car Model"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter the car model";
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: colorController,
          decoration: _inputDecoration("Car Color"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter the car color";
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: plateController,
          decoration: _inputDecoration("Plate Number"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter the plate number";
            }
            return null;
          },
        ),
      ],
    );
  }
}
