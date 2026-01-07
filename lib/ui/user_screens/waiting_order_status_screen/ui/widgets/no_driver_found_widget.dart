import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:lottie/lottie.dart';

class NoDriverFoundWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NoDriverFoundWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          AppImage().noResult,
          width: 200.w,
          height: 200.h,
          fit: BoxFit.contain,
        ),
        verticalSpace(16),
        Text(
          "no_driver_found_title".tr(),
          style: TextStyles.font22Blackbold(),
          textAlign: TextAlign.center,
        ),
        verticalSpace(10),
        Text(
          message,
          style: TextStyles.font12GreyDarkSemiBold(),
          textAlign: TextAlign.center,
        ),
        verticalSpace(49),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.mainColor,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: onRetry,
            child: Text(
              "retry_request".tr(),
              style: TextStyles.font12Blackbold(),
            ),
          ),
        ),
      ],
    );
  }
}
