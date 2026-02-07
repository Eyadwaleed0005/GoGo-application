import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/driver_daily_amount-helper.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart'; // للترجمة
import 'total_money_background.dart';

class TotalMoneyToday extends StatelessWidget {
  const TotalMoneyToday({super.key});

  @override
  Widget build(BuildContext context) {
    return TotalMoneyBackground(
      child: Stack(
        children: [
          // عنوان "Today Income"
          PositionedDirectional(
            top: 7.h,
            start: 6.w, // بدل left
            child: Text(
              "today_income".tr(),
              style: TextStyles.font15whitebold(),
            ),
          ),

          // حاوية المجموع
          PositionedDirectional(
            bottom: 8.h,
            end: 4.w, // بدل right
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: ColorPalette.backgroundColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      bottom: 20.h,
                      start: 7.w, // بدل left
                    ),
                    child: Text(
                      "total".tr(),
                      style: TextStyles.font12blackBold(),
                    ),
                  ),
                  horizontalSpace(8),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 35.h,
                      end: 4.w, // بدل right
                    ),
                    child: FutureBuilder<int>(
                      future: DriverDailyAmountHelper.getDailyAmount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(
                            "loading".tr(),
                            style: TextStyles.font12blackBold(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            "error".tr(),
                            style: TextStyles.font12blackBold(),
                          );
                        } else {
                          final total = snapshot.data ?? 0;
                          return Text(
                            "$total EG",
                            style: TextStyles.font12blackBold(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
