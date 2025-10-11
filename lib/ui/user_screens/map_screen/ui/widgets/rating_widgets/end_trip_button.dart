import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit/location_service_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/review_cubit/review_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit/route_cubit.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'review_dialog.dart';

class EndTripButton extends StatelessWidget {
  const EndTripButton({super.key});

  Future<void> _endTrip(BuildContext context) async {
    final rating = await ReviewDialog.show(context);
    if (rating == null) return;

await context.read<ReviewCubit>().sendReviewAndSaveHistory(rating);
    final state = context.read<ReviewCubit>().state;

    if (state is ReviewSuccess) {
      showBlockingAnimation(
        context: context,
        message: "review_sent_success".tr(),
        animationAsset: AppImage().sucsses,
        autoClose: true,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPreferenceKeys.userOrderId);
      await prefs.remove(SharedPreferenceKeys.orderStatus);
      await prefs.remove(SharedPreferenceKeys.driverIdTrip);
      await prefs.remove(SharedPreferenceKeys.savedRoutes);
      await prefs.remove(SharedPreferenceKeys.savedRoutesPoints);

      context.read<LocationServiceCubit>().updateOrderStatus("cancel");
      context.read<RouteCubit>().clearRoute(removeSaved: true);

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homeScreen,
        (route) => false,
      );
    } else if (state is ReviewError) {
      showBlockingAnimation(
        context: context,
        message: state.message,
        animationAsset: AppImage().error,
        autoClose: true,
        duration: const Duration(seconds: 3),
      );
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () async => _endTrip(context),
        child: Text(
          "end_trip".tr(),
          style: TextStyles.font11blackSemiBold()
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
