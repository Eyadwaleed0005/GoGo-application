import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/driver_daily_amount-helper.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'total_money_background.dart';

class TotalMoneyToday extends StatelessWidget {
  const TotalMoneyToday({super.key});

  @override
  Widget build(BuildContext context) {
    return TotalMoneyBackground(
      child: Stack(
        children: [
          Positioned(
            top: 7.h,
            left: 6.w,
            child: Text(
              "Today's income",
              style: TextStyles.font15whitebold(),
            ),
          ),
          Positioned(
            bottom: 8.h,
            right: 4.w,
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
                    padding: EdgeInsets.only(bottom: 20.h, left: 7.w),
                    child: Text(
                      "Total",
                      style: TextStyles.font12blackBold(),
                    ),
                  ),
                  horizontalSpace(8),
                  Padding(
                    padding:  EdgeInsets.only(top: 35.h, right: 4.w),
                    child: FutureBuilder<int>(
                      future: DriverDailyAmountHelper.getDailyAmount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(
                            "Loading...",
                            style: TextStyles.font12blackBold(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            "Error",
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
