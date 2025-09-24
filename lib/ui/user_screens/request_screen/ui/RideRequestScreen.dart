import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/ui/user_screens/request_screen/logic/cubit/ride_request_screen_cubit.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/widgets/order_app_bar.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/widgets/trip_details_form.dart';
import 'package:gogo/ui/user_screens/waiting_order_status_screen/ui/waiting_order_status_screen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

class RideRequestScreen extends StatelessWidget {
  final String from;
  final String to;
  final mb.Point? fromLatLng;
  final mb.Point? toLatLng;
  final double? distanceKm;
  final double? durationMin;

  const RideRequestScreen({
    super.key,
    required this.from,
    required this.to,
    this.fromLatLng,
    this.toLatLng,
    this.distanceKm,
    this.durationMin,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RideRequestScreenCubit(distanceKm ?? 0),
      child: BlocConsumer<RideRequestScreenCubit, RideRequestScreenState>(
        listener: (context, state) {
          if (state.status == RideRequestStatus.loading) {
            showBlockingAnimation(
              context: context,
              message: "creating_order".tr(),
              animationAsset: AppImage().loading,
            );
          } else if (state.status == RideRequestStatus.success) {
            hideBlockingAnimation(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const WaitingOrderStatusScreen(),
              ),
              (route) => false, 
            );
          } else if (state.status == RideRequestStatus.error) {
            hideBlockingAnimation(context);
            showBlockingAnimation(
              context: context,
              message: state.errorMessage ?? "something_wrong".tr(),
              animationAsset: AppImage().error,
              autoClose: true,
              duration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: OrderAppBar(
              title: "order_now".tr(),
            ),
            body: SafeArea(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 134.h),
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorPalette.mainColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TripDetailsForm(
                            from: from,
                            to: to,
                            fromLatLng: fromLatLng!,
                            toLatLng: toLatLng!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 3,
                    child: Image.asset(
                      AppImage().carOrder,
                      width: 250.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
