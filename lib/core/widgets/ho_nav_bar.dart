import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:gogo/core/style/app_color.dart';

class HoNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double height;

  const HoNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.height = 45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      decoration: BoxDecoration(
        color: ColorPalette.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home, size: 18.sp),
            title: Text("home".tr()),
            selectedColor: ColorPalette.mainColor,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.grid_view, size: 18.sp),
            title: Text("service".tr()),
            selectedColor: ColorPalette.mainColor,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person, size: 18.sp),
            title: Text("profile".tr()),
            selectedColor: ColorPalette.mainColor,
          ),
        ],
      ),
    );
  }
}
