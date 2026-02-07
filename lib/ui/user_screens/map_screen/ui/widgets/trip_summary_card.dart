import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/style/textstyles.dart';

class TripSummaryCard extends StatelessWidget {
  final double distanceKm;
  final String timeText; // بدل double durationMin

  const TripSummaryCard({
    super.key,
    required this.distanceKm,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(
              Icons.route,
              "distance".tr(),
              "$distanceKm Km",
              Colors.blue[800],
            ),
            _buildItem(
              Icons.schedule,
              "time".tr(),
              timeText,
              Colors.green[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String value, Color? color) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 12.sp),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              "$label: $value",
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font8Blackbold(),
            ),
          ),
        ],
      ),
    );
  }
}
