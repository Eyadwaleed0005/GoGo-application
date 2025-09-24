import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/confirmation_dialog.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ActionButtonsWidget({
    super.key,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.green,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.2),
            ),
            onPressed: () {
              ConfirmationDialog.show(
                context: context,
                title: "confirm_accept".tr(),
                confirmText: "yes".tr(),
                content: "accept_order_message".tr(),
                showCancel: true,
                onConfirm: onAccept,
              );
            },
            child: Text(
              "accept".tr(),
              style: TextStyles.font12BlackSemiBold(),
            ),
          ),
        ),
      ],
    );
  }
}
