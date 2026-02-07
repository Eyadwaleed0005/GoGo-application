import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class SendScreenButton extends StatelessWidget {
  final VoidCallback onConfirm;
  const SendScreenButton({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      height: 40.h,
      child: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.textColor1,
          foregroundColor: ColorPalette.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Text(
          "wallet_confirm_payment".tr(),
          style: TextStyles.font12whitebold(),
        ),
      ),
    );
  }
}
