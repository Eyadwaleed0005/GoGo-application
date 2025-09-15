import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'driver_profile_avatar.dart';
import 'driver_status_button.dart';
import 'edit_button.dart';

class DriverProfileHeader extends StatelessWidget {
  const DriverProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double avatarRadius = 35.r; 
    return SizedBox(
      width: double.infinity,
      height: 100.h, 
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: DriverProfileAvatar(
              radius: avatarRadius,
            ),
          ),
          Positioned(
            left: 0.5.sw + avatarRadius - -25.w,
            bottom: 40.h,
            child: const DriverStatusButton(),
          ),
          Positioned(
            bottom: 2.h,
            left: 0.5.sw - avatarRadius - 38.w,
            child: EditButton(
              onTap: () {
                debugPrint("Edit button tapped!");
              },
            ),
          ),
        ],
      ),
    );
  }
}
