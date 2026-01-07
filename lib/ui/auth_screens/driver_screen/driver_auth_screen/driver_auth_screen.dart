import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/app_system_ui.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/widgets/custom_outlined_button.dart';
import 'package:gogo/core/widgets/system_ui_wrapper.dart';

class DriverAuthScreen extends StatelessWidget {
  const DriverAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SystemUiWrapper(
      style: AppSystemUi.dark(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackTextButton(onTap: () => Navigator.pop(context)),
                  verticalSpace(20),
                  Center(
                    child: Container(
                      width: 181.w,
                      height: 181.w,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(
                          AppImage().driver,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 450.ms)
                      .slideX(
                        begin: 1, 
                        end: 0,
                        duration: 450.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  verticalSpace(30),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'drive_smarter'.tr(),
                          style: TextStyles.font21BlackBold(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalSpace(10),
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
                    ],
                  )
                      .animate(delay: 250.ms)
                      .fadeIn(duration: 500.ms)
                      .slideX(
                        begin: 1,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  verticalSpace(20),
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
                  )
                      .animate(delay: 550.ms)
                      .fadeIn(duration: 450.ms)
                      .slideX(
                        begin: 1,
                        end: 0,
                        duration: 450.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  verticalSpace(15),
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
                  )
                      .animate(delay: 750.ms)
                      .fadeIn(duration: 450.ms)
                      .slideX(
                        begin: 1,
                        end: 0,
                        duration: 450.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
