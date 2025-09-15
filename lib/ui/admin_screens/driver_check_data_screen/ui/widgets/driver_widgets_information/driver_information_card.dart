import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverInformationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String email;
  final int age;

  const DriverInformationCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.mainColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imageUrl,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
              ),
            ),
            verticalSpace(15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("الاسم", style: TextStyles.font10BlackSemiBold()),
            ),
            verticalSpace(4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: ColorPalette.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                name,
                style: TextStyles.font10BlackSemiBold(),
              ),
            ),
            verticalSpace(10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("الإيميل", style: TextStyles.font10BlackSemiBold()),
            ),
            verticalSpace(4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: ColorPalette.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                email,
                style: TextStyles.font10BlackSemiBold(),
              ),
            ),
            verticalSpace(10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("العمر", style: TextStyles.font10BlackSemiBold()),
            ),
            verticalSpace(4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "$age",
                style: TextStyles.font10BlackSemiBold(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
