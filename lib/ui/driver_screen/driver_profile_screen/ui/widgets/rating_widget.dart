import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/logic/cubit/driver_profile_screen_cubit.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverProfileScreenCubit, dynamic>(
      builder: (context, state) {
        double rating = 0.0;
        if (state is DriverProfileScreenLoaded) {
          rating = state.driverProfile.review;
        }

        double roundedRating = (rating * 10).roundToDouble() / 10;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: ColorPalette.textColor1,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Text(
                roundedRating.toStringAsFixed(1),
                style: TextStyles.font10whitebold(),
              ),
            ),
            horizontalSpace(10),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: index < roundedRating
                      ? ColorPalette.starsColor
                      : ColorPalette.fieldStroke,
                  size: 25.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
