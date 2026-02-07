import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gogo/core/const/const_things_of_admin.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/confirmation_dialog.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/ui/widgets/send_arrival_notification_button.dart';
import 'package:easy_localization/easy_localization.dart';

class TripActionCard extends StatelessWidget {
  final bool isTripStarted;
  final VoidCallback onStartTrip;
  final VoidCallback onEndTrip;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final String userPhone;
  final String distance;
  final String time;
  final String customerName;
  final String fromPlace;
  final String toPlace;

  const TripActionCard({
    super.key,
    required this.isTripStarted,
    required this.onStartTrip,
    required this.onEndTrip,
    required this.onCall,
    required this.onMessage,
    required this.userPhone,
    required this.customerName,
    required this.fromPlace,
    required this.toPlace,
    this.distance = "0 km",
    this.time = "0 min",
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.32.sp,
      minChildSize: 0.11.sp,
      maxChildSize: 0.45.sp,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: ColorPalette.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            boxShadow: [
              BoxShadow(blurRadius: 5.r, color: ColorPalette.textColor1),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ▪ شريط السحب
                Center(
                  child: Container(
                    width: 60.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: ColorPalette.mainColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                verticalSpace(12),

                // ▪ بيانات العميل
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      customerName,
                      style: TextStyles.font12Blackbold(),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(4),
                    Text(
                      userPhone,
                      style: TextStyles.font12Blackbold(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                verticalSpace(16),

               Container(
  padding: EdgeInsets.all(10.w),
  decoration: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(10.r),
  ),
  child: Text(
    isTripStarted
        ? "trip_to_destination".tr(namedArgs: {"place": toPlace})
        : "trip_to_customer".tr(namedArgs: {"place": fromPlace}),
    style: TextStyles.font12Blackbold(),
    textAlign: TextAlign.center,
  ),
),

                verticalSpace(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("distance_label".tr()),
                        Text(distance, style: TextStyles.font12Blackbold()),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("time_label".tr()),
                        Text(time, style: TextStyles.font12Blackbold()),
                      ],
                    ),
                  ],
                ),
                verticalSpace(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: onCall,
                          borderRadius: BorderRadius.circular(50.r),
                          child: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            radius: 24.r,
                            child: Icon(
                              Icons.call,
                              color: Colors.green,
                              size: 22.sp,
                            ),
                          ),
                        ),
                        verticalSpace(8),
                        Text(
                          "call".tr(),
                          style: const TextStyle(color: ColorPalette.textDark),
                        ),
                      ],
                    ),
                    SendArrivalNotificationButton(
                      projectId: ConstThingsOfUser.projectId,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: onMessage,
                          borderRadius: BorderRadius.circular(50.r),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            radius: 24.r,
                            child: FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                              size: 22.sp,
                            ),
                          ),
                        ),
                        verticalSpace(10),
                        Text(
                          "whatsapp".tr(),
                          style: const TextStyle(color: ColorPalette.textDark),
                        ),
                      ],
                    ),
                  ],
                ),
                verticalSpace(12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ConfirmationDialog.show(
                        context: context,
                        title: isTripStarted
                            ? "end_trip_confirm".tr()
                            : "start_trip_confirm".tr(),
                        confirmText: isTripStarted ? "end".tr() : "start".tr(),
                        onConfirm: isTripStarted ? onEndTrip : onStartTrip,
                        showCancel: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isTripStarted ? Colors.red : Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      isTripStarted ? "end_trip".tr() : "start_trip".tr(),
                      style: TextStyles.font15Blackbold(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
