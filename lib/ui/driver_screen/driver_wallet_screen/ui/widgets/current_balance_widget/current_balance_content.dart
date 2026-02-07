import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ استيراد الترجمة

class CurrentBalanceContent extends StatelessWidget {
  final int? wallet; 
  const CurrentBalanceContent({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpace(30),
          Text(
            "wallet_current_balance".tr(),          // ✅ مفتاح الترجمة
            style: TextStyles.font18whitebold(),
          ),
          verticalSpace(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              horizontalSpace(40),
              Text(
                wallet != null
                    ? "$wallet ${"wallet_currency".tr()}"   // ✅ العملة قابلة للترجمة
                    : "0 ${"wallet_currency".tr()}",
                style: TextStyles.font15whitebold(),
              ),
              horizontalSpace(12),
              Icon(
                Icons.arrow_right_alt,
                color: ColorPalette.backgroundColor,
                size: 32.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
