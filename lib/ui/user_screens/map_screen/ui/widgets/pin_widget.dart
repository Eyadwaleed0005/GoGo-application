import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  late final AnimationController _controller;
  late final Animation<double> _drop;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _drop = Tween<double>(begin: -35, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    if (!widget.isMoving) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedPinWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMoving) {
      _controller.reset();
    } else {
      if (!_controller.isAnimating && _controller.value == 0) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _sanitizeForEgypt(String raw) {
    var t = raw.trim();
    if (t.isEmpty) return "";

    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
    t = t.replaceAll(RegExp(r'\b[0-9A-Z]{3,}\+[0-9A-Z]{2,}\b'), '');
    t = t.replaceAll(RegExp(r'^[0-9A-Z]{3,}\+?[0-9A-Z]*\s*[,، ]*\s*'), '');
    t = t.replaceAll(
      RegExp(r'(جمهورية\s*مصر\s*العربية|مصر)\s*[،,]?\s*'),
      '',
    );
    t = t.replaceAll(RegExp(r'محافظة\s+\S+(\s+\S+)?\s*[،,]?\s*'), '');
    t = t.replaceAll(RegExp(r'\bقسم\s*(أول|ثاني|ثالث|رابع|خامس)?\b'), '');
    t = t.replaceAll(RegExp(r'\s*[،,]\s*'), '، ');
    t = t.replaceAll(RegExp(r'(،\s*){2,}'), '، ');
    t = t.replaceAll(RegExp(r'^\s*،\s*|\s*،\s*$'), '');
    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();

    return t;
  }

  bool _isValidGoogleName(String s) {
    final t = _sanitizeForEgypt(s);
    if (t.isEmpty) return false;
    if (t == "موقع غير معروف") return false;
    if (t.length < 4) return false;
    return true;
  }

  List<String> _toTwoLinesDetailed(String input) {
    final sanitized = _sanitizeForEgypt(input);

    final parts = sanitized
        .split('،')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return ["", ""];

    final line1 = parts.first;
    final line2 = parts.length > 1 ? parts.sublist(1).take(2).join('، ') : "";

    return [line1, line2];
  }

  @override
  Widget build(BuildContext context) {
    final hasName = _isValidGoogleName(widget.placeName);
    final showLoading = widget.isMoving || !hasName;

    final lines = _toTwoLinesDetailed(widget.placeName);
    final line1 = lines[0];
    final line2 = lines[1];

    return AnimatedBuilder(
      animation: _drop,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, _drop.value - 12),
              child: IntrinsicWidth(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.r,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    ),
                    child: showLoading
                        ? const SpinKitRotatingCircle(
                            color: ColorPalette.mainColor,
                            size: 22,
                          )
                        : Padding(
                            key: ValueKey("${line1}_$line2"),
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  line1,
                                  style: TextStyles.font10BlackSemiBold(),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (line2.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      line2,
                                      style: TextStyles.font10BlackSemiBold().copyWith(
                                        color: Colors.black54,
                                        fontSize: 9,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                ),
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
                      color: ColorPalette.mainColor,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, _drop.value),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette.mainColor,
                            ),
                          ),
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorPalette.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2.w,
                        height: 22.h,
                        color: ColorPalette.mainColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
