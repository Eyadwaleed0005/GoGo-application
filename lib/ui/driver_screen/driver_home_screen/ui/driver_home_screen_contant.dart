import 'package:easy_localization/easy_localization.dart';
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
                    padding: EdgeInsets.only(left: 20.w, top: 28.h, bottom: 3.h),
                    child: Text("home_title".tr(),
                        style: TextStyles.font25Blackbold()),
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
                  Text("welcome_driver".tr(), style: TextStyles.font15Blackbold()),
                  SizedBox(height: 8.h),
                  Text("earn_money".tr(), style: TextStyles.font15Blackbold()),
                  SizedBox(height: 8.h),
                  Text("safe_transport".tr(), style: TextStyles.font15Blackbold()),
                  SizedBox(height: 8.h),
                  Text("collaborate".tr(), style: TextStyles.font15Blackbold()),
                  SizedBox(height: 8.h),
                  Text("our_trust".tr(), style: TextStyles.font15Blackbold()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
