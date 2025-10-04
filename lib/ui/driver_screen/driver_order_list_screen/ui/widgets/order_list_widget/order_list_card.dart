import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/ui/widgets/order_list_widget/details_order_buttom.dart';

class OrderListCard extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final String time;
  final String location;
  final VoidCallback onTap;

  const OrderListCard({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.time,
    required this.location,
    required this.onTap,
  });

  String _filterLocation(String location) {
    return location.replaceAll(RegExp(r'[0-9]'), '');
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: ColorPalette.mainColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: 30.w,
                      height: 30.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  horizontalSpace(10),
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      userName,
                      style: TextStyles.font10BlackSemiBold(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Text(time, style: TextStyles.font10wGreyDarkBold()),
            ],
          ),
          verticalSpace(10),
          // صف الموقع
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20.sp,
                color: ColorPalette.textColor1,
              ),
              horizontalSpace(5),
              Expanded(
                child: Text(
                  _filterLocation(location),
                  style: TextStyles.font10Blackbold(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          // زر التفاصيل
          Align(
            alignment: Alignment.centerRight,
            child: DetailsOrderButton(onTap: onTap),
          ),
        ],
      ),
    );
  }
}
