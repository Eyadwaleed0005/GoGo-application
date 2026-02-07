import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/up_down_arrows_widget.dart';

class TitleHistoryWidget extends StatelessWidget {
  const TitleHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 141.w,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorPalette.textColor1,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Center(
            child: Row(
              children: [
                horizontalSpace(12),
                Text(
                  "trip_history".tr(),
                  style: TextStyles.font13whitesemiBold(),
                ),
                horizontalSpace(5),
                const UpDownArrowsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
