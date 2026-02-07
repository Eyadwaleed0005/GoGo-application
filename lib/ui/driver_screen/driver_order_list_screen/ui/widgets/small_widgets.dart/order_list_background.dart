import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';

class OrderListBackground extends StatelessWidget {
  const OrderListBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: ColorPalette.backgroundColor,
      ),
      child: Center(
        child: Image.asset(
          AppImage().notifications, 
          width: 250.w,
          height: 300.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
