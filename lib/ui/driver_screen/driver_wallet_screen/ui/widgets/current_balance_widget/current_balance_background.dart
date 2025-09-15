import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class CurrentBalanceBackground extends StatelessWidget {
  const CurrentBalanceBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorPalette.textColor1,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),

          Positioned.fill(
            child: Stack(
              children: [
                Positioned(
                  top: -20.h,
                  right: -20.w,
                  child: _buildCircle(80),
                ),
                Positioned(
                  bottom: -20.h,
                  left: -20.w,
                  child: _buildCircle(80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorPalette.circlesBackground,
      ),
    );
  }
}
