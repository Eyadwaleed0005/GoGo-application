import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart';

class UserHistoryCard extends StatelessWidget {
  final String from;
  final String to;
  final String paymentType;
  final String date;
  final String time;
  final String amount;

  const UserHistoryCard({
    super.key,
    required this.from,
    required this.to,
    required this.paymentType,
    required this.date,
    required this.time,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // ✅ عشان النص ياخد المساحة ويختصر لو طويل
                  child: Text(
                    "${'from'.tr()}: $from",
                    style: TextStyles.font12Blackbold(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: ColorPalette.textDark,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(paymentType, style: TextStyles.font10whitebold()),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // ✅ برضه هنا
                  child: Text(
                    "${'to'.tr()}: $to",
                    style: TextStyles.font12Blackbold(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: ColorPalette.textColor1,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(amount, style: TextStyles.font10whitebold()),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(date, style: TextStyles.font10GreyDarkSemiBold()),
                    Text(time, style: TextStyles.font10GreyDarkSemiBold()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
