import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/circle_progress_painter.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverTripCard extends StatefulWidget {
  final int count;
  final double? rating;
  final Color color;

  const DriverTripCard({
    super.key,
    required this.count,
    required this.color,
    this.rating,
  });

  @override
  State<DriverTripCard> createState() => _DriverTripCardState();
}

class _DriverTripCardState extends State<DriverTripCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCircle({
    required String text,
    required Color color,
    double? progress,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: CircleProgressPainter(
                progress: (progress ?? 1.0) * _controller.value,
                color: color,
              ),
              child: SizedBox(
                width: 80.w,
                height: 80.w,
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyles.font20Blackbold(),
                  ),
                ),
              ),
            );
          },
        ),
        verticalSpace(6),
        Text(label, style: TextStyles.font12GrayRegular()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: ColorPalette.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircle(
                  text: "${widget.count}",
                  color: widget.color,
                  label: "عدد الرحلات",
                ),
                if (widget.rating != null)
                  _buildCircle(
                    text: "${widget.rating}",
                    color: Colors.amber,
                    progress: (widget.rating! / 5),
                    label: "تقييم السائق",
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
