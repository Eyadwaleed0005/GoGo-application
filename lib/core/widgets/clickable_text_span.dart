import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gogo/core/style/app_color.dart';

class ClickableTextSpan extends StatelessWidget {
  final String normalText;
  final String clickableText;
  final VoidCallback onTap;
  final Color normalColor;
  final Color clickableColor;

  const ClickableTextSpan({
    super.key,
    required this.normalText,
    required this.clickableText,
    required this.onTap,
    this.normalColor = ColorPalette.filedInner,
    this.clickableColor = ColorPalette.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: normalText,
            style: TextStyle(color: normalColor),
          ),
          TextSpan(
            text: clickableText,
            style: TextStyle(
              color: clickableColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
