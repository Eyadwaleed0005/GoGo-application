import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverInfoForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController nationalIdController;
  final TextEditingController ageController;
  final TextEditingController licenseNumberController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController licenseExpiryController;

  const DriverInfoForm({
    super.key,
    required this.fullNameController,
    required this.nationalIdController,
    required this.ageController,
    required this.licenseNumberController,
    required this.emailController,
    required this.passwordController,
    required this.licenseExpiryController,
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
          controller: fullNameController,
          decoration: _inputDecoration("Driver Full Name"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter the full name";
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: nationalIdController,
          decoration: _inputDecoration("National ID"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter the national ID";
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: ageController,
          decoration: _inputDecoration("Age"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter the age";
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: licenseNumberController,
          decoration: _inputDecoration("License Number"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter the license number";
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: licenseExpiryController,
          decoration: _inputDecoration("License Expiry Date"),
          readOnly: true, // عشان ما يكتبش التاريخ بإيده
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              // نخزن التاريخ بصيغة ISO 8601
              licenseExpiryController.text = pickedDate
                  .toIso8601String(); // مثال: 2025-08-15T00:00:00
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please select the license expiry date";
            }
            return null;
          },
        ),
      ],
    );
  }
}
