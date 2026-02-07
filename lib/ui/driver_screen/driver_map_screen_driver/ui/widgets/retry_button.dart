import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class RetryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? label;                 // اجعلها nullable بدون tr() هنا
  final Color buttonColor;
  final Color textColor;
  final IconData icon;

  const RetryButton({
    super.key,
    required this.onPressed,
    this.label,                         // نمرر null أو نص جاهز
    this.buttonColor = ColorPalette.mainColor,
    this.textColor = ColorPalette.textColor1,
    this.icon = Icons.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(
        label ?? "retry".tr(),           // الترجمة هنا داخل build
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
    );
  }
}
