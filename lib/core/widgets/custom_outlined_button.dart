import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final double? width;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor = ColorPalette.mainColor,
    this.textColor = ColorPalette.textColor1,
    this.height = 50,
    this.borderRadius = 10,
    this.borderWidth = 1.5,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? width!.w : double.infinity,
      height: height.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: borderWidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyles.font11blackMediam().copyWith(color: textColor),
        ),
      ),
    );
  }
}
