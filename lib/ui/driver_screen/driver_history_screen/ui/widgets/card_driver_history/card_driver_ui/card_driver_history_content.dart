import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/small_widgets/data_time_widget.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/small_widgets/star_rating_widget.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/up_down_arrows_widget.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/small_widgets/locations_widget.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/small_widgets/trip_price_widget.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/small_widgets/way_of_pay_widget.dart';

class CardDriverHistoryContent extends StatelessWidget {
  final int rating;
  final String firstLocation;
  final String secondLocation;
  final String price;
  final String wayOfPay;
  final String date;
  final String time;
  final TextStyle textStyle;

  const CardDriverHistoryContent({
    super.key,
    required this.rating,
    required this.firstLocation,
    required this.secondLocation,
    required this.price,
    required this.wayOfPay,
    required this.date,
    required this.time,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Stack(
        children: [
          Positioned(
            top: 8.h,
            right: 3.w,
            child: const UpDownArrowsWidget(iconSize: 18),
          ),
          Positioned(
            top: 3.h,
            left: 8.w,
            child: Row(
              children: [
                StarRatingWidget(rating: rating, size: 16),
                SizedBox(width: 8.w),
                WayOfPayWidget(wayOfPay: wayOfPay),
              ],
            ),
          ),
          Positioned(
            top: 36.h,
            left: 7.w,
            right: 10.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationsWidget(
                  firstLocation: firstLocation,
                  secondLocation: secondLocation,
                ),
                verticalSpace(25),
                DateTimeRow(date: date, time: time, textStyle: textStyle),
              ],
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 2.w,
            right: 5.w,
            child: Align(
              alignment: Directionality.of(context) == TextDirection.rtl
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: TripPriceWidget(price: price),
            ),
          ),
        ],
      ),
    );
  }
}
