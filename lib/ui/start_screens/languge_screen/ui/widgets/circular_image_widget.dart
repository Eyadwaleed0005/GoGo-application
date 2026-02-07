import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularImageWidget extends StatelessWidget {
  final String imagePath;
  final double size;
  final double blurRadius;
  final Offset shadowOffset;
  final BoxFit fit;

  const CircularImageWidget({
    Key? key,
    required this.imagePath,
    this.size = 200,
    this.blurRadius = 10,
    this.shadowOffset = const Offset(0, 5),
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: blurRadius.r,
              offset: Offset(shadowOffset.dx, shadowOffset.dy.h),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
