import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart';

class CarInfoForm extends StatefulWidget {
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

  @override
  State<CarInfoForm> createState() => _CarInfoFormState();
}

class _CarInfoFormState extends State<CarInfoForm> {
  String? selectedType;
  bool isOtherSelected = false;

  final List<Map<String, String>> carTypes = [
    {"key": "taxi", "label": "car_type_taxi"},
    {"key": "scooter", "label": "car_type_scooter"},
    {"key": "other", "label": "car_type_other"},
  ];

  @override
  void initState() {
    super.initState();
    final currentValue = widget.brandController.text.trim().toLowerCase();
    if (currentValue == 'taxi' || currentValue == 'scooter') {
      selectedType = currentValue;
      isOtherSelected = false;
    } else if (currentValue.isNotEmpty) {
      selectedType = 'other';
      isOtherSelected = true;
    }
  }

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
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedType,
          items: carTypes
              .map(
                (type) => DropdownMenuItem(
                  value: type["key"],
                  child: Text(type["label"]!.tr()),
                ),
              )
              .toList(),
          decoration: _inputDecoration("car_brand"),
          dropdownColor: Colors.white,
          onChanged: (value) {
            setState(() {
              selectedType = value;
              isOtherSelected = value == 'other';
              if (!isOtherSelected) {
                widget.brandController.text = value ?? '';
              } else {
                widget.brandController.clear();
              }
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "enter_car_brand".tr();
            }
            return null;
          },
        ),

        if (isOtherSelected) ...[
          verticalSpace(8),
          TextFormField(
            controller: widget.brandController,
            decoration: _inputDecoration("car_brand_name"),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "enter_car_brand".tr();
              }
              return null;
            },
          ),
        ],
        verticalSpace(12),
        TextFormField(
          controller: widget.modelController,
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
          controller: widget.colorController,
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
          controller: widget.plateController,
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
