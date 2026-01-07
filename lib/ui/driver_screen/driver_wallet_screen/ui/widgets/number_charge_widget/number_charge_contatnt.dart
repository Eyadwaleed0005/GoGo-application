import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/const/const_things_of_admin.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class NumberChargeContatnt extends StatelessWidget {
  const NumberChargeContatnt({super.key});

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorPalette.black,
        content: Text("Copied: $text", style: TextStyles.font10whitebold()),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "wallet_recharge_money".tr(),
            style: TextStyles.font15whitebold(),
          ),

          verticalSpace(20),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 45.w, top: 3.h),
            child: SizedBox(
              width: 150.w,
              height: 40.h,
              child: TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: ConstThingsOfUser.numberOfOwner,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.copy, color: ColorPalette.textColor1),
                    onPressed: () => copyToClipboard(
                      context,
                      ConstThingsOfUser.numberOfOwner,
                    ),
                  ),
                ),
                style: TextStyles.font12Blackbold(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
