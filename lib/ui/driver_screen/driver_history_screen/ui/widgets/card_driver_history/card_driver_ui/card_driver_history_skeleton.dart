import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gogo/core/style/app_color.dart';

class CardDriverHistorySkeleton extends StatelessWidget {
  const CardDriverHistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.all(12.r),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: ColorPalette.mainColor.withOpacity(0.5),
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
                    (index) => Container(
                      width: 16.w,
                      height: 16.w,
                      margin: EdgeInsets.only(right: 4.w),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                const Spacer(),
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 20.h,
              color: Colors.white,
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              height: 20.h,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    width: 100.w,
                    height: 16.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
