import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';

class WayOfPayWidget extends StatelessWidget {
  final String wayOfPay;

  const WayOfPayWidget({super.key, required this.wayOfPay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          wayOfPay,
          style: TextStyles.font12Blackbold()
        ),
      ),
    );
  }
}
