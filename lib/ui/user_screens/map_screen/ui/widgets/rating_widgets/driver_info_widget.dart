import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_info.dart';
import 'package:easy_localization/easy_localization.dart';

class DriverInfoWidget extends StatelessWidget {
  final DriverInfo driver;

  const DriverInfoWidget({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: ColorPalette.backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: driver.driverPhoto.isNotEmpty
                ? NetworkImage(driver.driverPhoto)
                : AssetImage(AppImage().defultProfileAccount) as ImageProvider,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.driverFullname.isNotEmpty
                      ? driver.driverFullname
                      : "unknown_driver".tr(),
                  style: TextStyles.font12Blackbold(),
                ),
                SizedBox(height: 4.h),
                Text(
                  driver.phoneNumber.isNotEmpty
                      ? "0${driver.phoneNumber}" // ✅ يضيف صفر في الأول
                      : "no_phone_available".tr(),
                  style: TextStyles.font10GreyDarkSemiBold(),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20.sp),
              SizedBox(width: 4.w),
              Text(
                driver.review.toStringAsFixed(1), // يطلع 1.5 بدل 1.521739...
                style: TextStyles.font12BlackSemiBold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
