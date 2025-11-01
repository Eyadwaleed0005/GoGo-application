import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/style/app_color.dart';

class DriverProfileDetails extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String gender;
  final String carBrand;

  const DriverProfileDetails({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.gender,
    required this.carBrand,
  });

  String _translateGender(String g) {
    switch (g.toLowerCase()) {
      case 'male':
        return "ذكر";
      case 'female':
        return "أنثى";
      default:
        return "غير محدد";
    }
  }

  String _translateCar(String car) {
    switch (car.toLowerCase()) {
      case 'taxi':
        return "تاكسي";
      case 'scooter':
        return "إسكوتر";
      default:
        return car;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45.r,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: ColorPalette.backgroundColor,
        ),
        verticalSpace(10),
        Text(
          name,
          style: TextStyles.font18Blackbold(),
          textAlign: TextAlign.center,
        ),
        verticalSpace(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, color: ColorPalette.mainColor, size: 20.sp),
            SizedBox(width: 5.w),
            Text(
              _translateGender(gender),
              style: TextStyles.font12GrayRegular(),
            ),
            SizedBox(width: 20.w),
            Icon(
              Icons.directions_car,
              color: ColorPalette.mainColor,
              size: 20.sp,
            ),
            SizedBox(width: 5.w),
            Text(
              _translateCar(carBrand),
              style: TextStyles.font12GrayRegular(),
            ),
          ],
        ),
      ],
    );
  }
}
