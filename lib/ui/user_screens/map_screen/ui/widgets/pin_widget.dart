import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';


class AnimatedPinWidget extends StatefulWidget {
  final String placeName;
  final bool isMoving;

  const AnimatedPinWidget({
    super.key,
    required this.placeName,
    required this.isMoving,
  });

  @override
  State<AnimatedPinWidget> createState() => _AnimatedPinWidgetState();
}

class _AnimatedPinWidgetState extends State<AnimatedPinWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _drop;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _drop = Tween<double>(begin: -25, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedPinWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isMoving) {
      _controller.reset(); 
    } else {
      _controller.forward(); 
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.placeName.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxWidth: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.r,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Text(
              widget.placeName,
              style: TextStyles.font10Blackbold(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _drop,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _drop.value),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 16.w,
                            height: 16.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                          ),
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2.w,
                        height: 20.h,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
