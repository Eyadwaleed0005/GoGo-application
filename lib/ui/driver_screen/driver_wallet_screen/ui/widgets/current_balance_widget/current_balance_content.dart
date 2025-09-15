import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class CurrentBalanceContent extends StatelessWidget {
  final int? wallet; 
  const CurrentBalanceContent({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpace(30),
          Text(
            "Current Balance",
            style: TextStyles.font18whitebold(),
          ),
          verticalSpace(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              horizontalSpace(40),
              Text(
                wallet != null ? "$wallet EGP" : "0 EGP", 
                style: TextStyles.font15whitebold(),
              ),
              horizontalSpace(12),
              Icon(
                Icons.arrow_right_alt,
                color: ColorPalette.backgroundColor,
                size: 32.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
