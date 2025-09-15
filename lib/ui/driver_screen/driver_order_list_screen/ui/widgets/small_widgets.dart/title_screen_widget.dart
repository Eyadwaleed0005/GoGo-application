import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class TitleScreenWidget extends StatelessWidget {
  const TitleScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:  [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: ColorPalette.mainColor,
          child: Icon(
            Icons.notifications_none, 
            color: ColorPalette.textColor1,
            size: 22.sp,
          ),
        ),
        horizontalSpace(8),
        Text(
          'Order List',
          style: TextStyles.font15Blackbold()
        ),
      ],
    );
  }
}
