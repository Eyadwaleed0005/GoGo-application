import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class TripInfoPanel extends StatelessWidget {
  final double driverToCustomerDistance;
  final double driverToCustomerTime;
  final double customerToDestinationDistance;
  final double customerToDestinationTime;

  const TripInfoPanel({
    super.key,
    required this.driverToCustomerDistance,
    required this.driverToCustomerTime,
    required this.customerToDestinationDistance,
    required this.customerToDestinationTime,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.15,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
          decoration: BoxDecoration(
            color: ColorPalette.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: ColorPalette.black,
                blurRadius: 8.r,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50.w,
                    height: 6.h,
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: ColorPalette.mainColor,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    tr('trip_route'),
                    style: TextStyles.font15Blackbold(),
                  ),
                ),
                verticalSpace(13),
                _buildRow(
                  icon: Icons.directions_car,
                  color: Colors.blue,
                  title: tr('driver_to_customer'),
                  distance: driverToCustomerDistance,
                  time: driverToCustomerTime,
                ),
                verticalSpace(12),
                _buildRow(
                  icon: Icons.location_on,
                  color: Colors.green,
                  title: tr('customer_to_destination'),
                  distance: customerToDestinationDistance,
                  time: customerToDestinationTime,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow({
    required IconData icon,
    required Color color,
    required String title,
    required double distance,
    required double time,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.font10Blackbold()),
              verticalSpace(5),
              Text(
                tr(
                  'distance_time',
                  namedArgs: {
                    'distance': distance.toStringAsFixed(2),
                    'time': time.toStringAsFixed(1),
                  },
                ),
                style: TextStyles.font12GreyDarkSemiBold(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
