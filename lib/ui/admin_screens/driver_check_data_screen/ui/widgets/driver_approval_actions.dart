import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/logic/cubit/check_data_driver_screen_cubit.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/data/model/driver_status_update_model.dart';

class DriverApprovalActions extends StatelessWidget {
  final int driverId;

  const DriverApprovalActions({super.key, required this.driverId});

  void _confirmAction(BuildContext context, DriverApprovalStatus status) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("تأكيد", style: TextStyles.font15Blackbold()),
        content: Text(
          status == DriverApprovalStatus.approved
              ? "هل أنت متأكد من قبول السواق؟"
              : "هل أنت متأكد من رفض السواق؟",
          style: TextStyles.font15Blackbold(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("إلغاء", style: TextStyles.font10Blackbold()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: status == DriverApprovalStatus.approved
                  ? ColorPalette.moreGreen
                  : ColorPalette.moreRed,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<CheckDataDriverScreenCubit>().updateDriverStatus(
                    driverId: driverId,
                    status: status,
                  );
            },
            child: Text("نعم", style: TextStyles.font10Blackbold()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // زر القبول
        Expanded(
          child: SizedBox(
            height: 50.h,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.moreGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(Icons.check,
                  color: ColorPalette.backgroundColor, size: 25.sp),
              label: Text("قبول", style: TextStyles.font12Blackbold()),
              onPressed: () =>
                  _confirmAction(context, DriverApprovalStatus.approved),
            ),
          ),
        ),
        horizontalSpace(12.w),
        Expanded(
          child: SizedBox(
            height: 50.h,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.moreRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(Icons.close,
                  color: ColorPalette.backgroundColor, size: 25.sp),
              label: Text("رفض", style: TextStyles.font12Blackbold()),
              onPressed: () =>
                  _confirmAction(context, DriverApprovalStatus.reject),
            ),
          ),
        ),
      ],
    );
  }
}
