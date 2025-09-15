import 'package:flutter/material.dart';
import 'package:gogo/core/helper/spacer.dart';

class DateTimeRow extends StatelessWidget {
  final String date;
  final String time;
  final TextStyle textStyle;

  const DateTimeRow({
    super.key,
    required this.date,
    required this.time,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Text(
          date, 
          style: textStyle,
        ),
       horizontalSpace(6), 
        Text(
          "|", 
          style: textStyle,
        ),
        horizontalSpace(6), 
        Text(
          time,
          style: textStyle,
        ),
      ],
    );
  }
}
