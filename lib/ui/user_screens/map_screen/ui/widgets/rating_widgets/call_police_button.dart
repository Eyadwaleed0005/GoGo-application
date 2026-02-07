import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class CallPoliceButton extends StatelessWidget {
  const CallPoliceButton({super.key});

  Future<void> _callPolice() async {
    const policeNumber = "tel:122";
    if (await canLaunchUrl(Uri.parse(policeNumber))) {
      await launchUrl(Uri.parse(policeNumber));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: _callPolice,
        child: Text(
          "call_police".tr(),
          style: TextStyles.font11blackSemiBold()
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
