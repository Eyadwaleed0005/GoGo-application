import 'package:flutter/material.dart';
import 'package:gogo/core/style/textstyles.dart';

class BackTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final TextStyle? textStyle;

  const BackTextButton({
    super.key,
    required this.onTap,
    this.text = 'Back',
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: textStyle ?? TextStyles.font11MainColorSemiBold(),
      ),
    );
  }
}
