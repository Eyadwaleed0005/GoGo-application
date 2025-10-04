import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class CardDriverHistory extends StatelessWidget {
  final int rating;
  final String from;
  final String to;
  final String wayOfPay;
  final String price;
  final String date;
  final String time;
  final Color containerColor;
  final Color circleColor;

  const CardDriverHistory({
    super.key,
    required this.rating,
    required this.from,
    required this.to,
    required this.wayOfPay,
    required this.price,
    required this.date,
    required this.time,
    required this.containerColor,
    required this.circleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 20.sp,
                    color: index < rating ? Colors.yellow : Colors.grey,
                  ),
                ),
              ),
              horizontalSpace(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorPalette.backgroundColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(wayOfPay, style: TextStyles.font12Blackbold()),
              ),
              const Spacer(),
              Expanded(
                flex: 4,
                child: Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87,
                  ),
                  child: const Center(
                    child: Icon(Icons.compare_arrows, color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationBox(from),
              SizedBox(height: 8.h),
              _locationBox(to),
            ],
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: TextStyles.font10whitebold(),
                    ),
                    verticalSpace(8),
                    Text(
                      time,
                      style: TextStyles.font10whitebold(),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "total_price".tr(namedArgs: {"price": price.toString()}),
                  style: TextStyles.font12Blackbold(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationBox(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(text, style: TextStyles.font10Blackbold()),
    );
  }
}
