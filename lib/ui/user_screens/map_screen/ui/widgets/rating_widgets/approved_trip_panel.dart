import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_info.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/review_cubit/review_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/rating_widgets/driver_info_widget.dart';
import 'end_trip_button.dart';
import 'call_police_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ApprovedTripPanel extends StatefulWidget {
  const ApprovedTripPanel({super.key});

  @override
  State<ApprovedTripPanel> createState() => _ApprovedTripPanelState();
}

class _ApprovedTripPanelState extends State<ApprovedTripPanel> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().fetchDriverInfo();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.r,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5.h,
                  width: 50.w,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                BlocBuilder<ReviewCubit, ReviewState>(
                  builder: (context, state) {
                    if (state is DriverInfoLoaded) {
                      final driver = state.driver;
                      return Column(
                        children: [
                          DriverInfoWidget(driver: driver),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              onPressed: driver.phoneNumber.isNotEmpty
                                  ? () =>
                                        _makePhoneCall("0${driver.phoneNumber}")
                                  : null,
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              label: Text(
                                "call_driver".tr(),
                                style: TextStyles.font12whitebold(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        DriverInfoWidget(driver: DriverInfo()),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            onPressed: null,
                            icon: const Icon(Icons.phone, color: Colors.white),
                            label:  Text(
                               "call_driver".tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 12.h),
                const EndTripButton(),
                SizedBox(height: 12.h),
                const CallPoliceButton(),
                 SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
