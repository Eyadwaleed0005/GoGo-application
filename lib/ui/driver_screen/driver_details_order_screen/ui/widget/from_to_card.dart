import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class FromToCard extends StatelessWidget {
  final String fromPlace;
  final String toPlace;
  final String price;
  final String distance;
  final String tripType;
  final String passengers;

  const FromToCard({
    super.key,
    required this.fromPlace,
    required this.toPlace,
    required this.price,
    required this.distance,
    required this.tripType,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorPalette.mainColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
              decoration: ShapeDecoration(
                color: ColorPalette.backgroundColor,
                shape: const StadiumBorder(),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.location_on,
                      color: ColorPalette.textColor1, size: 25.sp),
                  horizontalSpace(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From :", style: TextStyles.font10Blackbold()),
                        Text(fromPlace, style: TextStyles.font12Blackbold()),
                        verticalSpace(3)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
              decoration: ShapeDecoration(
                color: ColorPalette.backgroundColor,
                shape: const StadiumBorder(),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.location_on,
                      color: ColorPalette.textColor1, size: 25.sp),
                  horizontalSpace(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("To :", style: TextStyles.font10Blackbold()),
                        Text(toPlace, style: TextStyles.font12Blackbold()),
                        verticalSpace(3)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    decoration: ShapeDecoration(
                      color: ColorPalette.backgroundColor,
                      shape: const StadiumBorder(),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Trip Price",
                          style: TextStyles.font9GreyDarkSemiBold(),
                        ),
                        verticalSpace(4),
                        Text(
                          "$price EGP",
                          style: TextStyles.font12Blackbold(),
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalSpace(8),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    decoration: ShapeDecoration(
                      color: ColorPalette.backgroundColor,
                      shape: const StadiumBorder(),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Trip Distance",
                          style: TextStyles.font9GreyDarkSemiBold(),
                        ),
                        verticalSpace(4),
                        Text(
                          "$distance km",
                          style: TextStyles.font12Blackbold(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              decoration: ShapeDecoration(
                color: ColorPalette.backgroundColor,
                shape: const StadiumBorder(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Trip Type",
                      style: TextStyles.font9GreyDarkSemiBold(),
                    ),
                  ),
                  verticalSpace(4),
                  Center(
                    child: Text(
                      tripType,
                      style: TextStyles.font12Blackbold(),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              decoration: ShapeDecoration(
                color: ColorPalette.backgroundColor,
                shape: const StadiumBorder(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Passengers",
                      style: TextStyles.font9GreyDarkSemiBold(),
                    ),
                  ),
                  verticalSpace(4),
                  Center(
                    child: Text(
                      passengers,
                      style: TextStyles.font12Blackbold(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
