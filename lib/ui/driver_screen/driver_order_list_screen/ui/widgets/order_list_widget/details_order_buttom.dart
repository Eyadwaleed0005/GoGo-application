import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DetailsOrderButton extends StatelessWidget {
  final VoidCallback? onTap; 

  const DetailsOrderButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: ColorPalette.backgroundColor,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Text(
          "Details",
          style: TextStyles.font12Blackbold().copyWith(
            color:ColorPalette.textDark,
          ),
        ),
      ),
    );
  }
}
