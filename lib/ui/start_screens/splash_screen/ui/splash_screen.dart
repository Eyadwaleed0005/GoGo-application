import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/repo/driver_status_repository.dart';
import 'package:gogo/ui/start_screens/splash_screen/logic/cubit/splash_screen_cubit.dart';
import 'package:lottie/lottie.dart';
import 'package:gogo/core/routes/app_images_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashScreenCubit(DriverStatusRepository())..checkAuth(),
      child: BlocListener<SplashScreenCubit, SplashScreenState>(
        listener: (context, state) {
          if (state is SplashScreenDriverStartTrip ||
              state is SplashScreenDriverEndTrip) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.driverMapScreen,
              (route) => false,
            );
          } else if (state is SplashScreenDriverApproved) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.driverHomeScreen,
              (route) => false,
            );
          } else if (state is SplashScreenDriverPending) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.onWaitingDriver,
              (route) => false,
            );
          } else if (state is SplashScreenDriverRejected) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.rejectDriverScreen,
              (route) => false,
            );
          } else if (state is SplashScreenPassenger) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homeScreen,
              (route) => false,
            );
          } else if (state is SplashScreenUnAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.accountTypeScreen,
              (route) => false,
            );
          } else if (state is SplashScreenUnAuthenticatedToLanguage) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.languageScreen,
              (route) => false,
            );
          } else if (state is SplashScreenFailure) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.accountTypeScreen,
              (route) => false,
            );
          }
        },
        child: Scaffold(
          backgroundColor: ColorPalette.backgroundColor,
          body: Center(
            child: Lottie.asset(
              AppImage().splashScreenAnimation,
              width: 2000.w,
              height: 2000.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
