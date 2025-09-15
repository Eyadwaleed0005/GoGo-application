import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/core/widgets/custom_refresh_widget.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/repo/driver_pay_repository.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/repo/driver_wallet_repository.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/logic/cubit/driver_wallet_screen_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/ui/widgets/current_balance_widget/current_balance_widget.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/ui/widgets/number_charge_widget/number_charge_widget.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/ui/widgets/proof_of_payment_widget.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/ui/widgets/send_screen_buttom.dart';

class DriverWalletScreen extends StatelessWidget {
  const DriverWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverWalletScreenCubit(
        DriverPayRepository(),
        DriverWalletRepository(),
      )..fetchWallet(),
      child: BlocListener<DriverWalletScreenCubit, DriverWalletScreenState>(
        listener: (context, state) {
          if (state.isLoading) {
            showBlockingAnimation(
              context: context,
              message: "Uploading payment...",
              animationAsset: AppImage().loading,
            );
          } else {
            hideBlockingAnimation(context);
          }

          if (state.showSuccessAnimation) {
            showBlockingAnimation(
              context: context,
              message:
                  "Payment submitted successfully! Your request is under review.",
              animationAsset: AppImage().sucsses,
              autoClose: true,
              duration: const Duration(seconds: 4),
              onClosed: () {
                context.read<DriverWalletScreenCubit>().resetDriverPay();
              },
            );
          }

          if (state.error != null) {
            showBlockingAnimation(
              context: context,
              message: state.error!,
              animationAsset: AppImage().error,
              autoClose: true,
              duration: const Duration(seconds: 2),
              onClosed: () {
                context.read<DriverWalletScreenCubit>().clearError();
              },
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child:
                BlocBuilder<DriverWalletScreenCubit, DriverWalletScreenState>(
                  builder: (context, state) {
                    return CustomRefreshWidget(
                      onReload: () async {
                        context.read<DriverWalletScreenCubit>().fetchWallet();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          children: [
                            const CurrentBalanceWidget(),
                            verticalSpace(10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.h,
                                horizontal: 5.w,
                              ),
                              decoration: BoxDecoration(
                                color: ColorPalette.mainColor,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                "Recharge",
                                style: TextStyles.font15Blackbold(),
                              ),
                            ),
                            verticalSpace(10),
                            const NumberChargeWidget(),
                            verticalSpace(10),
                            const ProofOfPaymentWidget(),
                            verticalSpace(30),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Builder(
                                builder: (context) {
                                  return SendScreenButton(
                                    onConfirm: () {
                                      context
                                          .read<DriverWalletScreenCubit>()
                                          .submitPayment(0);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
