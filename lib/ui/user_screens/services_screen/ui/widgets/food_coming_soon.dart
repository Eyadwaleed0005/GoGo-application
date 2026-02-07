import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/style/textstyles.dart';

class FoodComingSoon extends StatelessWidget {
  const FoodComingSoon({super.key});

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
              "food_services".tr(),
              textAlign: TextAlign.center,
              style: TextStyles.font12Blackbold(),
            ),
          ),
          Text(
            "coming_soon".tr(),
            style: TextStyles.font10redSemiBold(),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
