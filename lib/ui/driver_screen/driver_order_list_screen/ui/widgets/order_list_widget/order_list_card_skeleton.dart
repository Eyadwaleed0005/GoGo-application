import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';

class OrderListCardSkeleton extends StatelessWidget {
  const OrderListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: ColorPalette.mainColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    horizontalSpace(10),
                    Container(
                      width: 120.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                  ],
                ),
                Container(
                  width: 40.w,
                  height: 12.h,
                  color: Colors.white,
                ),
              ],
            ),
            verticalSpace(10),
            // صف الموقع
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 20.sp, color: Colors.white),
                horizontalSpace(5),
                Container(
                  width: 180.w,
                  height: 12.h,
                  color: Colors.white,
                ),
              ],
            ),
            verticalSpace(10),
            // زر التفاصيل
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 60.w,
                height: 20.h,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
