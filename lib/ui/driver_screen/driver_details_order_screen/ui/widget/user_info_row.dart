import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/textstyles.dart';

class UserInfoRow extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String time;

  const UserInfoRow({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
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
          time,
          style:TextStyles.font10GreyDarkSemiBold(),
        ),
      ],
    );
  }
}
