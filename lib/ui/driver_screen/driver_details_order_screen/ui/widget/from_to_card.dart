import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/services/trip_type_translator.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart';

class FromToCard extends StatelessWidget {
  final String fromPlace;
  final String toPlace;
  final String price;
  final String distance;
  final String tripType;
  final String passengers;
  final String paymentWay; 

  const FromToCard({
    super.key,
    required this.fromPlace,
    required this.toPlace,
    required this.price,
    required this.distance,
    required this.tripType,
    required this.passengers,
    required this.paymentWay, 
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
                  Icon(
                    Icons.location_on,
                    color: ColorPalette.textColor1,
                    size: 25.sp,
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("from".tr(), style: TextStyles.font10Blackbold()),
                        Text(fromPlace, style: TextStyles.font12Blackbold()),
                        verticalSpace(3),
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
                  Icon(
                    Icons.location_on,
                    color: ColorPalette.textColor1,
                    size: 25.sp,
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("to".tr(), style: TextStyles.font10Blackbold()),
                        Text(toPlace, style: TextStyles.font12Blackbold()),
                        verticalSpace(3),
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
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 10.w,
                    ),
                    decoration: ShapeDecoration(
                      color: ColorPalette.backgroundColor,
                      shape: const StadiumBorder(),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "trip_price".tr(),
                          style: TextStyles.font9GreyDarkSemiBold(),
                        ),
                        verticalSpace(4),
                        Text("$price EGP", style: TextStyles.font12Blackbold()),
                      ],
                    ),
                  ),
                ),
                horizontalSpace(8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 10.w,
                    ),
                    decoration: ShapeDecoration(
                      color: ColorPalette.backgroundColor,
                      shape: const StadiumBorder(),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "trip_distance".tr(),
                          style: TextStyles.font9GreyDarkSemiBold(),
                        ),
                        verticalSpace(4),
                        Text(
                          "${double.parse(distance).toStringAsFixed(1)} km",
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "trip_type".tr(),
                    style: TextStyles.font9GreyDarkSemiBold(),
                  ),
                  verticalSpace(4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          tripType,
                          style: TextStyles.font12Blackbold(),
                        ),
                      ),
                      verticalSpace(2),
                      Center(
                        child: Text(
                          TripTypeTranslator.toArabic(tripType),
                          style: TextStyles.font12Blackbold(),
                        ),
                      ),
                    ],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "passengers".tr(),
                    style: TextStyles.font9GreyDarkSemiBold(),
                  ),
                  verticalSpace(4),
                  Text(passengers, style: TextStyles.font12Blackbold()),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "payment_way".tr(),
                    style: TextStyles.font9GreyDarkSemiBold(),
                  ),
                  verticalSpace(4),
                 Text(paymentWay.tr(), style: TextStyles.font12Blackbold()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
