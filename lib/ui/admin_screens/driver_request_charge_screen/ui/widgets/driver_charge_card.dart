import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/ui/widgets/charge_action_buttons.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/ui/widgets/charge_image_widget.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/ui/widgets/charge_value_input.dart';

class DriverChargeCard extends StatefulWidget {
  final dynamic charge;

  const DriverChargeCard({super.key, required this.charge});

  @override
  State<DriverChargeCard> createState() => _DriverChargeCardState();
}

class _DriverChargeCardState extends State<DriverChargeCard> {
  final TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.mainColor,
      margin:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChargeImageWidget(imageUrl: widget.charge.image),
            verticalSpace(10),
            Text(
              widget.charge.name,
              style: TextStyles.font12Blackbold()
            ),
            verticalSpace(10),
            Row(
              children: [
                Expanded(child: ChargeValueInput(controller: valueController)),
                horizontalSpace(10),
                ChargeActionButtons(
                  chargeId: widget.charge.chargeId, 
                  valueController: valueController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
