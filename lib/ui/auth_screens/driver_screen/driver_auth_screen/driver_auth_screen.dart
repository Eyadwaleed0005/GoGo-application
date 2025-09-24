import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/widgets/custom_outlined_button.dart';

class DriverAuthScreen extends StatelessWidget {
  const DriverAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackTextButton(onTap: () => Navigator.pop(context)),
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  width: 181.w,
                  height: 181.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(AppImage().driver, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Text(
                  'drive_smarter'.tr(),
                  style: TextStyles.font21BlackBold(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  'join_drivers_start_earning'.tr(),
                  style: TextStyles.font11GrayRegular(),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  'while_providing_safe_rides'.tr(),
                  style: TextStyles.font11GrayRegular(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: CustomButton(
                  text: 'become_driver'.tr(),
                  backgroundColor: ColorPalette.mainColor,
                  height: 30.h,
                  width: 222.w,
                  borderRadius: 3.r,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.driverRegisterScreen,
                    );
                  },
                ),
              ),
              SizedBox(height: 15.h),
              Center(
                child: CustomOutlinedButton(
                  text: 'login_as_driver'.tr(),
                  height: 30.h,
                  width: 200.w,
                  borderRadius: 3.r,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.driverLoginScreen,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}