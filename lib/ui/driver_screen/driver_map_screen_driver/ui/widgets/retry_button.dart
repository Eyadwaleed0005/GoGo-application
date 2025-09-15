import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class RetryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color buttonColor;
  final Color textColor;
  final IconData icon;

  const RetryButton({
    super.key,
    required this.onPressed,
    this.label = "إعادة المحاولة",
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
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding:  EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
    );
  }
}
