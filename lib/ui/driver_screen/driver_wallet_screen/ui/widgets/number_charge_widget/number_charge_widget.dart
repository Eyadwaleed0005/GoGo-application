
import 'package:flutter/material.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/ui/widgets/current_balance_widget/current_balance_background.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/ui/widgets/number_charge_widget/number_charge_contatnt.dart';


class NumberChargeWidget extends StatelessWidget {
  const NumberChargeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:  [
        CurrentBalanceBackground(), 
        NumberChargeContatnt()
      ],
    );
  }
}
