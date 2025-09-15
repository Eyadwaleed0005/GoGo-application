import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/card_driver_ui/card_driver_history_background.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/card_driver_ui/card_driver_history_content.dart';

class CardDriverHistory extends StatelessWidget {
  final Color containerColor;
  final Color circleColor;
  final int rating;
  final String firstLocation;
  final String secondLocation;
  final String price;
  final String wayOfPay;
  final String date;
  final String time;
  final TextStyle textStyle;

  const CardDriverHistory({
    super.key,
    required this.containerColor,
    required this.circleColor,
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
    return SizedBox(
      width: double.infinity,
      height: 160.h,
      child: Stack(
        children: [
          CardDriverHistoryBackground(
            colorContainr: containerColor,
            colorCircle: circleColor,
          ),
          CardDriverHistoryContent(
            rating: rating,
            firstLocation: firstLocation,
            secondLocation: secondLocation,
            price: price,
            wayOfPay: wayOfPay,
            date: date,
            time: time,
            textStyle: textStyle,
          ),
        ],
      ),
    );
  }
}
