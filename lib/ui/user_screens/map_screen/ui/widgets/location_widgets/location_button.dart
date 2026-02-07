import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class LocationButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LocationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "locate",
      backgroundColor: ColorPalette.backgroundColor,
      onPressed: onPressed,
      child: Icon(
        Icons.navigation, 
        size: 22.sp,
        color: ColorPalette.red,
      ),
    );
  }
}
