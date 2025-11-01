import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/circle_progress_painter.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverStatCard extends StatefulWidget {
  final Map<String, int> stats; 
  final String label;
  final Color color;

  const DriverStatCard({
    super.key,
    required this.stats,
    required this.label,
    required this.color,
  });

  @override
  State<DriverStatCard> createState() => _DriverStatCardState();
}

class _DriverStatCardState extends State<DriverStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maleCount = widget.stats["رجال"] ?? 0;
    final femaleCount = widget.stats["نساء"] ?? 0;
    final total = maleCount + femaleCount;

    return Card(
      elevation: 4,
      color: ColorPalette.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: CircleProgressPainter(
                    progress: _controller.value,
                    color: widget.color,
                  ),
                  child: SizedBox(
                    width: 80.w,
                    height: 80.w,
                    child: Center(
                      child: Text(
                        "$total",
                        style: TextStyles.font25Blackbold(),
                      ),
                    ),
                  ),
                );
              },
            ),
            verticalSpace(8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyles.font15Blackbold(),
            ),
            verticalSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSmallCircle("عربية", widget.stats["عربية"] ?? 0),
                _buildSmallCircle("تاكسي", widget.stats["تاكسي"] ?? 0),
                _buildSmallCircle("إسكوتر", widget.stats["إسكوتر"] ?? 0),
              ],
            ),

            verticalSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSmallCircle("رجال", maleCount),
                _buildSmallCircle("نساء", femaleCount),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSmallCircle(String label, int value) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: CircleProgressPainter(
                progress: _controller.value,
                color: widget.color,
              ),
              child: SizedBox(
                width: 60.w,
                height: 60.w,
                child: Center(
                  child: Text(
                    "$value",
                    style: TextStyles.font18Blackbold(),
                  ),
                ),
              ),
            );
          },
        ),
        verticalSpace(6),
        Text(
          label,
          style: TextStyles.font12GrayRegular(),
        ),
      ],
    );
  }
}
