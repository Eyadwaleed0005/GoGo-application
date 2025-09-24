import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ إضافة
import 'driver_information_text_field.dart';

class DriverInformationWidget extends StatefulWidget {
  const DriverInformationWidget({super.key});

  @override
  State<DriverInformationWidget> createState() => _DriverInformationWidgetState();
}

class _DriverInformationWidgetState extends State<DriverInformationWidget> {
  String? name;
  String? email;
  String? phone;

  @override
  void initState() {
    super.initState();
    _loadDriverInfo();
  }

  Future<void> _loadDriverInfo() async {
    final displayName = await SecureStorageHelper.getdata(key: SecureStorageKeys.displayName);
    final userEmail = await SecureStorageHelper.getdata(key: SecureStorageKeys.email);
    final userPhone = await SecureStorageHelper.getdata(key: SecureStorageKeys.phoneNumber);

    setState(() {
      name = displayName ?? "N/A";
      email = userEmail ?? "N/A";
      phone = userPhone ?? "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.mainColor,
      margin: EdgeInsets.all(12.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "driver_information".tr(), // ✅ عنوان قابل للترجمة
              style: TextStyles.font12Blackbold(),
            ),
            verticalSpace(14),

            DriverInformationTextField(
              title: "name".tr(), // ✅ قابل للترجمة
              value: name ?? "...",
            ),
            verticalSpace(12),

            DriverInformationTextField(
              title: "email".tr(), // ✅ قابل للترجمة
              value: email ?? "...",
            ),
            verticalSpace(12),

            DriverInformationTextField(
              title: "phone_number".tr(), // ✅ قابل للترجمة
              value: phone ?? "...",
            ),
          ],
        ),
      ),
    );
  }
}
