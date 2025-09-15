import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverHomeScreenContant extends StatelessWidget {
  const DriverHomeScreenContant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // الجزء العلوي (الكونتينر البرتقالي + Home + الصورة)
            Container(
              width: double.infinity,
              height: 290.h,
              decoration: BoxDecoration(
                color: ColorPalette.mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      top: 28.h,
                      bottom: 3.h,
                    ),
                    child: Text("Home", style: TextStyles.font25Blackbold()),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 7.h),
                        child: Image.asset(
                          AppImage().business,
                          height: 190.h,
                          width: 180.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to our driver community.",
                    style: TextStyles.font15Blackbold(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "You can now earn more and more money through our app.",
                    style: TextStyles.font15Blackbold(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "We strive to make rough roads easier for passengers and select the best drivers for safe and fast transportation.",
                    style: TextStyles.font15Blackbold(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "You can now collaborate with us in building our community.",
                    style: TextStyles.font15Blackbold(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "We place our full trust in you to be a respectable face for us among the community.",
                    style: TextStyles.font15Blackbold(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
