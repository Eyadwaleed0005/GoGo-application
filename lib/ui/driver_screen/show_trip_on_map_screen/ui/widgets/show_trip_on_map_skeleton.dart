import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/helper/spacer.dart';

class ShowTripOnMapSkeleton extends StatelessWidget {
  const ShowTripOnMapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 0.4.sh, 
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
        decoration: BoxDecoration(
          color: ColorPalette.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: ColorPalette.textDark.withOpacity(0.1),
              blurRadius: 8.r,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50.w,
                height: 6.h,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: ColorPalette.mainColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 120.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50.r), 
                ),
              ),
            ),
            verticalSpace(20),
            _buildSkeletonRow(),
            verticalSpace(15),
            _buildSkeletonRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50.r), 
                ),
              ),
              verticalSpace(8),
              Container(
                width: 180.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50.r), 
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
