import 'package:easy_localization/easy_localization.dart';
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
          controller: fullNameController,
          decoration: _inputDecoration("driver_full_name"),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "enter_full_name".tr();
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: nationalIdController,
          decoration: _inputDecoration("national_id"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "enter_national_id".tr();
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: ageController,
          decoration: _inputDecoration("age"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "enter_age".tr();
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: licenseNumberController,
          decoration: _inputDecoration("license_number"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "enter_license_number".tr();
            }
            return null;
          },
        ),
        verticalSpace(12),
        TextFormField(
          controller: licenseExpiryController,
          decoration: _inputDecoration("license_expiry_date"),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              licenseExpiryController.text = pickedDate.toIso8601String();
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "select_license_expiry".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
