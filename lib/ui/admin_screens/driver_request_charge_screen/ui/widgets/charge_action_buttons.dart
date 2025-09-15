import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/logic/cubit/driver_request_charge_screen_cubit.dart';

class ChargeActionButtons extends StatelessWidget {
  final int chargeId;
  final TextEditingController valueController;

  const ChargeActionButtons({
    super.key,
    required this.chargeId,
    required this.valueController,
  });

  void _showApproveConfirmation(BuildContext context, int chargeId, int value) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("تأكيد"),
        content: Text("هل أنت متأكد أنك تريد إرسال مبلغ $value جنيه للسائق؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              context.read<DriverRequestChargeScreenCubit>().sendAction(
                chargeId: chargeId,
                action: "approve",
                value: value,
              );
              Navigator.of(ctx).pop();
            },
            child: const Text("تأكيد"),
          ),
        ],
      ),
    );
  }

  void _showRejectConfirmation(BuildContext context, int chargeId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("رفض الطلب"),
        content: const Text("هل أنت متأكد أنك لا تريد قبول هذا الطلب؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              context.read<DriverRequestChargeScreenCubit>().sendAction(
                chargeId: chargeId,
                action: "reject",
                value: 0,
              );
              Navigator.of(ctx).pop();
            },
            child: const Text("تأكيد"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon:  Icon(Icons.check, color: ColorPalette.moreGreen,size: 25.sp),
          onPressed: () {
            final value = int.tryParse(valueController.text);
            if (value == null) {
              showBlockingAnimation(
                context: context,
                message: "الرجاء إدخال قيمة صحيحة",
                animationAsset: AppImage().error,
                autoClose: true,
                duration: const Duration(seconds: 2),
              );
              return;
            }
            _showApproveConfirmation(context, chargeId, value);
          },
        ),
        IconButton(
          icon:  Icon(Icons.close, color: ColorPalette.moreRed,size: 25.sp,),
          onPressed: () {
            _showRejectConfirmation(context, chargeId);
          },
        ),
      ],
    );
  }
}
