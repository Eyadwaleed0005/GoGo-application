import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;

  const OtpInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        appContext: context,
        length: 5,
        obscureText: false,
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (_) {},
        textStyle: TextStyles.font10BlackSemiBold(),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8.r),
          fieldHeight: 36.h,
          fieldWidth: 36.w,
          activeColor: ColorPalette.mainColor,
          selectedColor: ColorPalette.mainColor,
          inactiveColor: ColorPalette.mainColor,
          inactiveFillColor: Colors.transparent,
          activeFillColor: Colors.transparent,
          selectedFillColor: Colors.transparent,
          disabledColor: ColorPalette.mainColor,
          borderWidth: 1,
        ),
      ),
    );
  }
}
