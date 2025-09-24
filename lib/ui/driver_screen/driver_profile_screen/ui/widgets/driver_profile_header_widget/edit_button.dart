import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class EditButton extends StatelessWidget {
  final VoidCallback onTap;

  const EditButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: ColorPalette.mainColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          "edit".tr(), // ✅ مفتاح للترجمة
          style: TextStyles.font10Blackbold(),
        ),
      ),
    );
  }
}
