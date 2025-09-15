import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';

class FoodComingSoon extends StatelessWidget {
  final String centerText;
  final String rightText;

  const FoodComingSoon({
    super.key,
    this.centerText = "Food and other services",
    this.rightText = "Coming\nSoon",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              centerText,
              textAlign: TextAlign.center,
              style: TextStyles.font12Blackbold(),
            ),
          ),
          Text(
            rightText,
            style: TextStyles.font10redSemiBold(),
            textAlign: TextAlign.right, 
          ),
        ],
      ),
    );
  }
}
