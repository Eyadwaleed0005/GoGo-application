import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DriverDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorPalette.mainColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: ColorPalette.textColor1),
        onPressed: () => Navigator.pop(context),
      ),
     title: Text(
  "order_details".tr(),
  style: TextStyles.font15Blackbold(),
),

      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
