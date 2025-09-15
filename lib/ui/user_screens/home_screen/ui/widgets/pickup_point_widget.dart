import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class PickupPointWidget extends StatelessWidget {
  final VoidCallback onTap;

  const PickupPointWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: ColorPalette.textDark, size: 28.sp),
            SizedBox(width: 20.w), 
            Text(
              "Enter pickup point",
              style: TextStyles.font12GreyDarkSemiBold(),
            ),
            Spacer(), 
            Icon(Icons.arrow_forward,color: ColorPalette.fieldStroke,size: 20.sp,),
          ],
        ),
      ),
    );
  }
}
