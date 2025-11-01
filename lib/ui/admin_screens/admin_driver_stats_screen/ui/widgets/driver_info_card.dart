import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:gogo/core/helper/circle_progress_painter.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverInfoCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double rating;
 // final int tripsCount;//
  final VoidCallback? onTap;

  const DriverInfoCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
   // required this.tripsCount,//
    this.onTap,
  });

  @override
  State<DriverInfoCard> createState() => _DriverInfoCardState();
}

class _DriverInfoCardState extends State<DriverInfoCard>
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Card(
        elevation: 5,
        color: ColorPalette.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35.r,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
              verticalSpace(10),
              Text(
                widget.name,
                style: TextStyles.font15Blackbold()
              ),
              verticalSpace(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBarIndicator(
                    rating: widget.rating,
                    itemBuilder: (context, index) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 18.sp,
                  ),
                  horizontalSpace(6),
                  Text(
                    widget.rating.toStringAsFixed(1),
                    style: TextStyles.font12GrayRegular(),
                  ),
                ],
              ),
              verticalSpace(20),
          /*    AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: CircleProgressPainter(
                      progress: _controller.value,
                      color: ColorPalette.mainColor,
                    ),
                    child: SizedBox(
                      width: 65.w,
                      height: 65.w,
                      child: Center(
                        child: Text(
                          "${widget.tripsCount}",
                          style: TextStyles.font20Blackbold(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              verticalSpace(8),
              Text("عدد الرحلات", style: TextStyles.font12GrayRegular()),*/
            ],
          ),
        ),
      ),
    );
  }
}
