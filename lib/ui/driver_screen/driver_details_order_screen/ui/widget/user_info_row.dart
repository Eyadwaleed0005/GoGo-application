import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:intl/intl.dart';

class UserInfoRow extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String time; // الوقت بصيغة ISO string مثل "2025-09-17T01:22:56.526811"

  const UserInfoRow({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final parsedTime = DateTime.tryParse(time)?.toLocal();
    final formattedTime =
        parsedTime != null ? DateFormat.jm().format(parsedTime) : time;

    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundImage: NetworkImage(imageUrl),
        ),
        horizontalSpace(12),
        Expanded(
          child: Text(
            name,
            style: TextStyles.font15Blackbold(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          formattedTime,
          style: TextStyles.font10GreyDarkSemiBold(),
        ),
      ],
    );
  }
}
