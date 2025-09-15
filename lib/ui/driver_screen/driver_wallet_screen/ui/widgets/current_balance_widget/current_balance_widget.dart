import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'current_balance_background.dart';
import 'current_balance_content.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/logic/cubit/driver_wallet_screen_cubit.dart';

class CurrentBalanceWidget extends StatelessWidget {
  const CurrentBalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CurrentBalanceBackground(),
        BlocBuilder<DriverWalletScreenCubit, DriverWalletScreenState>(
          builder: (context, state) {
            return CurrentBalanceContent(wallet: state.wallet);
          },
        ),
      ],
    );
  }
}
