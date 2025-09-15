import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating;       
  final int maxRating;    
  final double size;      
  final Color filledColor;
  final Color emptyColor;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 10,
    this.filledColor = ColorPalette.starsColor,
    this.emptyColor = ColorPalette.fieldStroke,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? filledColor : emptyColor,
          size: size.sp,
        );
      }),
    );
  }
}
