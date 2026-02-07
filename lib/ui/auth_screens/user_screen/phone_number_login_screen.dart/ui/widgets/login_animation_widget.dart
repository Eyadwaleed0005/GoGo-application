import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';

class LoginAnimationWidget extends StatelessWidget {
  final String? animationPath;
  final double? width;
  final double? height;

  const LoginAnimationWidget({
    super.key,
    this.animationPath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            animationPath ?? AppImage().loginAnimation,
            width: width ?? 200.w,
            height: height ?? 200.h,
            repeat: true,
          ),
          verticalSpace(8),
        ],
      ),
    );
  }
}
