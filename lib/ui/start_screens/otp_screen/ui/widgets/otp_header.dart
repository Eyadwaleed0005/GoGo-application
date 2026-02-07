import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/helper/spacer.dart';

class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Verification Code',
            style: TextStyles.font21BlackBold(),
          ),
        ),
        verticalSpace(10.h),
        Center(
          child: Text(
            'Enter the 5-digit code sent to your number',
            style: TextStyles.font11GrayRegular(),
          ),
        ),
      ],
    );
  }
}
