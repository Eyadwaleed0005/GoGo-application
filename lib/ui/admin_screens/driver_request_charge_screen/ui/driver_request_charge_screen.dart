import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/data/repo/top_up_driver_repository.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/logic/cubit/driver_request_charge_screen_cubit.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/ui/widgets/driver_charge_card.dart';

class DriverRequestChargeScreen extends StatelessWidget {
  const DriverRequestChargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DriverRequestChargeScreenCubit(TopUpRepository())..fetchTopUpRequests(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "طلبات الدفع",
            style: TextStyles.font15Blackbold(),
          ),
          centerTitle: true,
          backgroundColor: ColorPalette.mainColor,
        ),
        body: BlocConsumer<DriverRequestChargeScreenCubit,
            DriverRequestChargeScreenState>(
          listener: (context, state) {
            if (state is DriverRequestChargeActionSuccess) {
              showBlockingAnimation(
                context: context,
                message: "تم تنفيذ العملية بنجاح ",
                animationAsset: AppImage().sucsses,
                autoClose: true,
                duration: const Duration(seconds: 2),
              );
            } else if (state is DriverRequestChargeActionError) {
              showBlockingAnimation(
                context: context,
                message: state.message,
                animationAsset: AppImage().error,
                autoClose: true,
                duration: const Duration(seconds: 2),
              );
            }
          },
          builder: (context, state) {
            if (state is DriverRequestChargeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DriverRequestChargeLoaded) {
              if (state.requests.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimationBox(
                        message: "لا يوجد طلبات شحن حالياً",
                        animationAsset: AppImage().emptyBox,
                        autoClose: false,
                        textStyle: TextStyles.font10Blackbold(),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final charge = state.requests[index];
                  return DriverChargeCard(charge: charge);
                },
              );
            } else if (state is DriverRequestChargeError) {
              return Center(
                child: AnimationBox(
                  message: state.message,
                  animationAsset: AppImage().error,
                  autoClose: false,
                  textStyle: TextStyles.font10Blackbold(),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
