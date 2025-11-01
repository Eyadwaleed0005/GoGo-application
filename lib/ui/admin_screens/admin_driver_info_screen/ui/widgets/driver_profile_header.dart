import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;

  const DriverProfileHeader({
    super.key,
    required this.imageUrl,
    required this.name,
  });

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
      ],
    );
  }
}
