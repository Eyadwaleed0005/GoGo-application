import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/ui/user_screens/waiting_order_status_screen/data/repo/get_order_by_id_repository.dart';
import 'package:gogo/ui/user_screens/waiting_order_status_screen/logic/cubit/waiting_order_status_screen_cubit.dart';
import 'package:lottie/lottie.dart';

class WaitingOrderStatusScreen extends StatefulWidget {
  const WaitingOrderStatusScreen({super.key});

  @override
  State<WaitingOrderStatusScreen> createState() =>
      _WaitingOrderStatusScreenState();
}

class _WaitingOrderStatusScreenState extends State<WaitingOrderStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WaitingOrderStatusScreenCubit(GetOrderByIdRepository())
            ..startTrackingOrder(),
      child:
          BlocConsumer<
            WaitingOrderStatusScreenCubit,
            WaitingOrderStatusScreenState
          >(
            listener: (context, state) {
              if (!mounted) return; // حماية لو الشاشة اتقفلت

              if (state is WaitingOrderApproved) {
                Navigator.pushReplacementNamed(context, AppRoutes.mapScreen);
              }
              if (state is WaitingOrderCancelled ||
                  state is WaitingOrderCancelledManually) {
                Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
              }
            },
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.homeScreen,
                    (route) => false,
                  );
                  return false;
                },
                child: Scaffold(
                  backgroundColor: ColorPalette.backgroundColor,
                  body: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: _buildContent(context, state),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WaitingOrderStatusScreenState state,
  ) {
    if (state is WaitingOrderStatusError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppImage().error,
            width: 200.w,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          verticalSpace(20),
          Text(
            state.message,
            style: TextStyles.font10redSemiBold(),
            textAlign: TextAlign.center,
          ),
          verticalSpace(20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.mainColor,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              shape: const StadiumBorder(),
              elevation: 2,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeScreen,
                (route) => false,
              );
            },
            child: Text("back".tr(), style: TextStyles.font10Blackbold()),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          AppImage().searching,
          width: 200.w,
          height: 200.h,
          fit: BoxFit.contain,
        ),
        Text(
          "request_pending".tr(),
          style: TextStyles.font22Blackbold(),
          textAlign: TextAlign.center,
        ),
        verticalSpace(10),
        Text(
          "request_wait_description".tr(),
          style: TextStyles.font12GreyDarkSemiBold(),
          textAlign: TextAlign.center,
        ),
        verticalSpace(30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.red,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              context.read<WaitingOrderStatusScreenCubit>().cancelOrder();
            },
            child: Text(
              "cancel_request".tr(),
              style: TextStyles.font12whitebold(),
            ),
          ),
        ),
      ],
    );
  }
}
