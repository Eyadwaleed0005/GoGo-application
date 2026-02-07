import 'package:flutter/material.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart';

class BackTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;
  final TextStyle? textStyle;

  const BackTextButton({
    super.key,
    required this.onTap,
    this.text, 
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text?.tr() ?? 'back'.tr(), 
        style: textStyle ?? TextStyles.font11MainColorSemiBold(),
      ),
    );
  }
}
