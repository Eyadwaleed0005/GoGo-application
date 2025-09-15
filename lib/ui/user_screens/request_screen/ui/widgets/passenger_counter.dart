import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class PassengerCounter extends StatelessWidget {
  final int passengers;
  final ValueChanged<int> onChanged;
  final int minPassengers;
  final int maxPassengers;

  const PassengerCounter({
    super.key,
    required this.passengers,
    required this.onChanged,
    this.minPassengers = 1,
    this.maxPassengers = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // زرار ناقص
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: passengers > minPassengers
                  ? () => onChanged(passengers - 1)
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: passengers > minPassengers
                      ? Colors.red.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.remove,
                  color: passengers > minPassengers ? Colors.red : Colors.grey,
                  size: 24.sp,
                ),
              ),
            ),

            // العدد
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorPalette.fieldStroke.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "$passengers",
                  style: TextStyles.font18Blackbold().copyWith(fontSize: 20.sp),
                ),
              ),
            ),

            // زرار زائد
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: passengers < maxPassengers
                  ? () => onChanged(passengers + 1)
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: passengers < maxPassengers
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.add,
                  color: passengers < maxPassengers ? Colors.green : Colors.grey,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
