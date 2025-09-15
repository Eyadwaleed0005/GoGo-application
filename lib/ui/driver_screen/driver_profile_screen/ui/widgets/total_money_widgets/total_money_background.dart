import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class TotalMoneyBackground extends StatelessWidget {
  final Widget child;
  const TotalMoneyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: EdgeInsets.only(bottom: 2, left: 20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(height: 40.h, color: ColorPalette.moreBlue),
                      _buildBar(height: 50.h, color: ColorPalette.moreGreen),
                      _buildBar(height: 30.h, color: ColorPalette.moreRed),
                      _buildBar(height: 70.h, color: ColorPalette.moreGreen),
                      _buildBar(height: 50.h, color: ColorPalette.moreBlue),
                      _buildBar(height: 30.h, color: ColorPalette.moreRed),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            left: 13.w,
            child: _buildCircle(65, ColorPalette.circlesBackground),
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: _buildCircle(63, ColorPalette.circlesBackground),
          ),
          Positioned(
            top: 62.h,
            right: 57.w,
            child: _buildCircle(65, ColorPalette.circlesBackground),
          ),
          Positioned.fill(
            child: Padding(padding: EdgeInsets.all(16.w), child: child),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      height: size.h,
      width: size.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildBar({required double height, required Color color}) {
    return Container(
      width: 12.w,
      height: height,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.r),
      ),
    );
  }
}
