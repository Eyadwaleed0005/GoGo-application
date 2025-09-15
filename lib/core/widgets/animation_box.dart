import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/textstyles.dart';

class AnimationBox extends StatelessWidget {
  final String message;
  final String animationAsset;
  final bool autoClose;
  final TextStyle? textStyle;
  final Duration? duration;
  final VoidCallback? onClosed; // 👈 إضافة دعم onClosed

  const AnimationBox({
    super.key,
    required this.message,
    required this.animationAsset,
    this.autoClose = false,
    this.duration,
    this.textStyle,
    this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animationAsset,
            width: 200.w,
            height: 200.h,
            repeat: !autoClose,
            onLoaded: (composition) {
              if (autoClose) {
                final time = duration ?? const Duration(seconds: 3);
                Future.delayed(time, () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                    if (onClosed != null) {
                      onClosed!();
                    }
                  }
                });
              }
            },
          ),
          verticalSpace(10),
          Text(
            message,
            style: textStyle ?? TextStyles.font12whitebold(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void showBlockingAnimation({
  required BuildContext context,
  required String message,
  required String animationAsset,
  bool autoClose = false,
  Duration? duration,
  TextStyle? textStyle,
  VoidCallback? onClosed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: AnimationBox(
            message: message,
            animationAsset: animationAsset,
            autoClose: autoClose,
            duration: duration,
            textStyle: textStyle,
            onClosed: onClosed, 
          ),
        ),
      );
    },
  );
}

void hideBlockingAnimation(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}
