import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class CustomImageCard extends StatelessWidget {
  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;
  final double spaceBetweenImageAndPhoto;
  final String assetImage;
  final String title;
  final bool isComingSoon;
  final VoidCallback? onTap;

  const CustomImageCard({
    super.key,
    required this.width,
    required this.height,
    required this.assetImage,
    required this.title,
    this.onTap,
    required this.imageWidth,
    required this.imageHeight,
    required this.spaceBetweenImageAndPhoto,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: ColorPalette.backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isComingSoon)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Coming", style: TextStyles.font8redSemiBold()),
                      Text("Soon", style: TextStyles.font8redSemiBold()),
                    ],
                  ),
                ),
              ),
            Center(
              child: SizedBox(
                width: imageWidth.w,
                height: imageHeight.h,
                child: Image.asset(assetImage, fit: BoxFit.contain),
              ),
            ),
            verticalSpace(spaceBetweenImageAndPhoto),
            Text(title, style: TextStyles.font8Blackbold()),
          ],
        ),
      ),
    );
  }
}
