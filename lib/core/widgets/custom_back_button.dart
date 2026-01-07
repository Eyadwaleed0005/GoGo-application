import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5.h,
      left: 10.w,
      child: SafeArea(
        child: GestureDetector(
          onTap: onTap ?? () => Navigator.pop(context),
          child: Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: ColorPalette.black,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
