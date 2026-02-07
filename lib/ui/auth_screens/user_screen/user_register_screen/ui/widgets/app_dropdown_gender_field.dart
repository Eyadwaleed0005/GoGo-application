import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class AppDropdownGenderField extends StatelessWidget {
  final String hint;
  final String? value;
  final ValueChanged<String?> onChanged;
  final double horizontalPadding;

  const AppDropdownGenderField({
    super.key,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.horizontalPadding = 2,
  });

  @override
  Widget build(BuildContext context) {
    final genderItems = const [
      {'value': 'male', 'label': 'male'},
      {'value': 'female', 'label': 'female'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: hint.tr(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: ColorPalette.fieldStroke, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: ColorPalette.fieldStroke, width: 1.w),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value ?? 'male',
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            icon: Icon(
              Icons.arrow_drop_down,
              color: ColorPalette.fieldStroke,
              size: 22.sp,
            ),
            items: genderItems.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(
                  item['label']!.tr(),
                  style: TextStyles.font10BlackSemiBold(),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
