import 'package:flutter/material.dart';
import 'package:gogo/core/style/app_color.dart';

class CustomRefreshWidget extends StatelessWidget {
  final Future<void> Function() onReload;
  final Widget child;

  const CustomRefreshWidget({
    super.key,
    required this.onReload,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorPalette.textDark, 
      backgroundColor: ColorPalette.mainColor,
      displacement: 40,
      onRefresh: onReload,
      child: child,
    );
  }
}
