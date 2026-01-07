import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class NoteWidget extends StatelessWidget {
  final String note;

  const NoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: ColorPalette.mainColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ColorPalette.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
              decoration: ShapeDecoration(
                color: ColorPalette.black,
                shape: const StadiumBorder(),
              ),
              child: Text("note".tr(), style: TextStyles.font10whitebold()),
            ),
            verticalSpace(15),
            Text(note, style: TextStyles.font12Blackbold()),
          ],
        ),
      ),
    );
  }
}
