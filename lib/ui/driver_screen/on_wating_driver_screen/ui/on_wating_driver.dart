import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/repo/driver_status_repository.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/logic/cubit/on_wating_driver_screen_cubit.dart';
import 'package:lottie/lottie.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ أضف الاستيراد

class OnWaitingDriver extends StatelessWidget {
  const OnWaitingDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnWatingDriverScreenCubit(DriverStatusRepository())
        ..fetchDriverStatus(),
      child: BlocListener<OnWatingDriverScreenCubit, OnWatingDriverScreenState>(
        listener: (context, state) {
          if (state is OnWatingDriverScreenFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: ColorPalette.backgroundColor,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    AppImage().searching,
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    "driver_waiting_title".tr(),          // ✅ مفتاح ترجمة
                    style: TextStyles.font22Blackbold(),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(10),
                  Text(
                    "driver_waiting_message".tr(),        // ✅ مفتاح ترجمة
                    style: TextStyles.font12GreyDarkSemiBold(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
