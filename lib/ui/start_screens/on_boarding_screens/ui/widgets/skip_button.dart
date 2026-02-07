import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class SkipButton extends StatelessWidget {
  final BuildContext context;
  final String? route;

  const SkipButton({super.key, required this.context, this.route});

  @override
  Widget build(BuildContext _) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                route ?? AppRoutes.accountTypeScreen,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.mainColor,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text('skip'.tr(), style: TextStyles.font10blackMedium()),
          ),
        ],
      ),
    );
  }
}
