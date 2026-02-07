import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; 
  final Color backgroundColor;
  final double height;
  final double borderRadius;
  final double? width;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ColorPalette.mainColor,
    this.height = 45,
    this.borderRadius = 3,
    this.width,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: ColorPalette.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        child: Text(
          text,
          style: textStyle ?? TextStyles.font11blackSemiBold(),
        ),
      ),
    );
  }
}
