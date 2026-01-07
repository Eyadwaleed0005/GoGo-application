import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/data/model/driver_detils_arges_model.dart';

class DriverWaitingCard extends StatelessWidget {
  final int driverId;
  final String userId;
  final String driverFullname;
  final String email;
  final String status;

  const DriverWaitingCard({
    super.key,
    required this.driverId,
    required this.userId,
    required this.driverFullname,
    required this.email,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: ColorPalette.mainColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: ColorPalette.backgroundColor,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: ColorPalette.black, size: 18.sp),
                      horizontalSpace(8),
                      Expanded(
                        child: Text(
                          driverFullname,
                          style: TextStyles.font10Blackbold(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: ColorPalette.textColor3,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.email, color: ColorPalette.black, size: 18.sp),
                      horizontalSpace(8),
                      Expanded(
                        child: Text(
                          email,
                          style: TextStyles.font10Blackbold(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: ColorPalette.textColor3,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: ColorPalette.black, size: 18.sp),
                      horizontalSpace(8),
                      Expanded(
                        child: Text(
                          status,
                          style: TextStyles.font10Blackbold(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: ColorPalette.black, size: 18.sp),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.checkDataDriverScreen,
                  arguments: DriverDetailsArgs(
                    driverId: driverId,
                    userId: userId,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
