import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';

class SuggestionsIcons extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback? onTap; // حدث الضغط

  const SuggestionsIcons({
    super.key,
    required this.imagePath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r), 
      onTap: onTap,
      child: Container(
        width: 53.w,
        height: 53.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 30.w,
              height: 30.w,
              fit: BoxFit.contain,
            ),
            Text(
              label,
              style: TextStyles.font10Blackbold(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
