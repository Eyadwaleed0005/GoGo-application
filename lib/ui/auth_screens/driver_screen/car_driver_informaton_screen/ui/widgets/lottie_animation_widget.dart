import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends StatefulWidget {
  final String assetPath;
  final double width;
  final double height;
  final bool repeat;
  final VoidCallback? onCompleted; 

  const LottieAnimationWidget({
    super.key,
    required this.assetPath,
    this.width = 200,
    this.height = 200,
    this.repeat = false,
    this.onCompleted,
  });

  @override
  State<LottieAnimationWidget> createState() => _LottieAnimationWidgetState();
}

class _LottieAnimationWidgetState extends State<LottieAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Lottie.asset(
          widget.assetPath,
          repeat: widget.repeat,
          onLoaded: (composition) async {
            if (!widget.repeat && widget.onCompleted != null) {
              await Future.delayed(composition.duration);
              widget.onCompleted!();
            }
          },
        ),
      ),
    );
  }
}
