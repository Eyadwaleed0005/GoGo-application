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
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: SizedBox(
        width: double.infinity,
        height: 180.h,
        child: Container(
          decoration: BoxDecoration(
            color: colorContainr,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8.h,
                right: 4.w,
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
                bottom: 25.h,
                left: 4.w,
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
        ),
      ),
    );
  }
}
