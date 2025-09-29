import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardDriverHistoryBackground extends StatelessWidget {
  final Color colorContainr;
  final Color colorCircle;

  const CardDriverHistoryBackground({
    super.key,
    required this.colorContainr,
    required this.colorCircle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorContainr,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10.w,
            top: 8.h,
            child: Container(
              width: 55.w,
              height: 55.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorCircle,
              ),
            ),
          ),
          Positioned(
            left: 10.w,
            bottom: 8.h,
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorCircle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}