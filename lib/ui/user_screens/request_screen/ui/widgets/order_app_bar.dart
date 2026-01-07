import 'package:flutter/material.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
class OrderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Color backgroundColor;
  final TextStyle? titleTextStyle;
  final List<Widget>? actions;
  final double elevation;

  const OrderAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.backgroundColor = Colors.white,
    this.titleTextStyle,
    this.actions,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: true,
      leading: IconButton(
        icon:  Icon(Icons.arrow_back_ios, color: ColorPalette.black),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      ),
      title: Text(
        title,
        style: TextStyles.font15Blackbold(),
      ),
      actions: actions,
    );
  }
}
