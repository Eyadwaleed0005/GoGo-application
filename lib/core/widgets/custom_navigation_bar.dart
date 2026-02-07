import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StylishBottomBar(
      backgroundColor: ColorPalette.mainColor,
      option: DotBarOptions(dotStyle: DotStyle.tile),
      items: [
        BottomBarItem(
          icon: const FaIcon(FontAwesomeIcons.house),
          title: Text('home'.tr(), style: TextStyles.font10Blackbold()),
          selectedColor: ColorPalette.textDark,
          unSelectedColor: ColorPalette.textDark,
        ),
        BottomBarItem(
          icon: const FaIcon(FontAwesomeIcons.bell),
          title: Text('order'.tr(), style: TextStyles.font10Blackbold()),
          selectedColor: ColorPalette.textDark,
          unSelectedColor: ColorPalette.textDark,
        ),
        BottomBarItem(
          icon: const FaIcon(FontAwesomeIcons.clockRotateLeft),
          title: Text('history'.tr(), style: TextStyles.font10Blackbold()),
          selectedColor: ColorPalette.textDark,
          unSelectedColor: ColorPalette.textDark,
        ),
        BottomBarItem(
          icon: const FaIcon(FontAwesomeIcons.wallet),
          title: Text('wallet'.tr(), style: TextStyles.font10Blackbold()),
          selectedColor: ColorPalette.textDark,
          unSelectedColor: ColorPalette.textDark,
        ),
        BottomBarItem(
          icon: const FaIcon(FontAwesomeIcons.user),
          title: Text('profile'.tr(), style: TextStyles.font10Blackbold()),
          selectedColor: ColorPalette.textDark,
          unSelectedColor: ColorPalette.textDark,
        ),
      ],
      hasNotch: false,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
