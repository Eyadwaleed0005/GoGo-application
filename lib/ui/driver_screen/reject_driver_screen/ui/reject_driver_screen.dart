import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:lottie/lottie.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart'; 

class RejectDriverScreen extends StatelessWidget {
  const RejectDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AppImage().error,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              ),
              Text(
                "driver_rejected_title".tr(),         
                style: TextStyles.font22Blackbold(),
                textAlign: TextAlign.center,
              ),
              verticalSpace(10),
              Text(
                "driver_rejected_message".tr(),        
                style: TextStyles.font12GreyDarkSemiBold(),
                textAlign: TextAlign.center,
              ),
              verticalSpace(30),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.accountTypeScreen,
                      (route) => false,
                    );
                  },
                  child: Text(
                    "driver_rejected_retry".tr(),        
                    style: TextStyles.font15Blackbold(),
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
