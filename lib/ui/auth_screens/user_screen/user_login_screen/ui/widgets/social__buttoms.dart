import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final String assetIcon;
  final double height;
  final double borderRadius;
  final double? width;
  final bool showBorder;
  final Color? borderColor;
  final Color? textColor;
  final double iconSize;
  final bool showIconBackground;
  final double? widthBetweenTextAndIcon;

  const SocialButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.assetIcon,
    required this.backgroundColor,
    this.height = 43,
    this.borderRadius = 10,
    this.width,
    this.showBorder = false,
    this.borderColor,
    this.textColor,
    this.iconSize = 24,
    this.showIconBackground = true,
    this.widthBetweenTextAndIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Image.asset(
      assetIcon,
      width: iconSize.w,
      height: iconSize.w,
      fit: BoxFit.contain,
    );

    if (showIconBackground) {
      iconWidget = Container(
        width: 25.w,
        height: 25.w,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: iconWidget,
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          elevation: 0,
          side: showBorder
              ? BorderSide(color: borderColor ?? Colors.white, width: 1.5.w)
              : BorderSide.none,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              SizedBox(width: (widthBetweenTextAndIcon ?? 8).w),
              Text(
                text,
                style: TextStyles.font11SemiBold().copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
