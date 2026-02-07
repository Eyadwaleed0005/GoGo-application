import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:shimmer/shimmer.dart';

class DriverDetailsOrderSkeletonScreen extends StatelessWidget {
  const DriverDetailsOrderSkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(height: 14.h, color: Colors.white),
                  ),
                  SizedBox(width: 12.w),
                  Container(width: 40.w, height: 12.h, color: Colors.white),
                ],
              ),

              SizedBox(height: 18.h),
              Container(
                height: 360.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorPalette.mainColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),

              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                height: 100.h,
                decoration: BoxDecoration(
                  color: ColorPalette.mainColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: ColorPalette.mainColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: ColorPalette.textDark,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
