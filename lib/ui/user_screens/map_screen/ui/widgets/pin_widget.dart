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
  late AnimationController _controller;
  late Animation<double> _drop;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _drop = Tween<double>(
      begin: -35,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
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

  /// 🔍 تحليل ذكي للعنوان: يعرض الأدق المتاح بدون رموز أو أرقام
  String _extractAccurateArea(String input) {
    if (input.trim().isEmpty) return "No name";

    // تنظيف النص من الرموز، الأرقام، والإنجليزي
    String cleaned = input
        .replaceAll(RegExp(r'[0-9A-Za-z]'), '') // إزالة الأرقام والإنجليزي
        .replaceAll(
          RegExp(r'[()\[\]\-+_=!@#%^&*<>?/\\|.:;]'),
          '',
        ) // إزالة الرموز
        .replaceAll(RegExp(r'\s+'), ' ') // توحيد المسافات
        .trim();

    // تقسيم النص على الفواصل
    List<String> parts = cleaned
        .split(RegExp(r'[،,]'))
        .map((e) => e.trim())
        .toList();
    parts.removeWhere(
      (e) =>
          e.isEmpty ||
          e == "مصر" ||
          e.contains("مصر") ||
          e.contains("EG") ||
          e.contains("الرمز") ||
          e.length < 3,
    );

    if (parts.isEmpty) return "No name";

    // ترتيب منطقي: أول جزء هو الأدق (زي شارع - حي - مركز)
    for (String part in parts) {
      if (part.contains("شارع") ||
          part.contains("طريق") ||
          part.contains("منطقة") ||
          part.contains("حي") ||
          part.contains("مركز") ||
          part.contains("قسم") ||
          part.contains("قرية") ||
          part.contains("مدينة")) {
        return part;
      }
    }

    // لو مفيش حاجة من دول، نرجع أول حاجة مفيدة
    return parts.first.isNotEmpty ? parts.first : "No name";
  }

  @override
  Widget build(BuildContext context) {
    final showLoading = widget.isMoving;
    final areaName = _extractAccurateArea(widget.placeName);

    return AnimatedBuilder(
      animation: _drop,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ===================== البوكس =====================
            Transform.translate(
              offset: Offset(0, _drop.value - 12),
              child: IntrinsicWidth(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
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
                            key: ValueKey(areaName),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                            ),
                            child: Text(
                              areaName.isNotEmpty ? areaName : "No name",
                              style: TextStyles.font10BlackSemiBold(),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            /// ===================== الدبوس =====================
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
