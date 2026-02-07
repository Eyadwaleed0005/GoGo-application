import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ استيراد الترجمة

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  Future<void> _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: SecureStorageKeys.token);
    await storage.delete(key: SecureStorageKeys.userType);
    await SharedPreferencesHelper.removeData(
        key: SharedPreferenceKeys.statusOfAccountDriver);
    await SharedPreferencesHelper.removeData(
        key: SharedPreferenceKeys.driverCompleteRegister);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.accountTypeScreen,
      (route) => false,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorPalette.backgroundColor,
          title: Text(
            "logout_confirm_title".tr(),           // ✅ مفتاح ترجمة
            style: TextStyles.font10Blackbold(),
          ),
          content: Text(
            "logout_confirm_message".tr(),         // ✅ مفتاح ترجمة
            style: TextStyles.font10BlackMedium(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "logout_cancel".tr(),              // ✅ مفتاح ترجمة
                style: TextStyles.font8Blackbold(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.moreRed,
              ),
              child: Text(
                "logout_yes".tr(),                 // ✅ مفتاح ترجمة
                style: TextStyles.font8whiteSemiBold(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showLogoutDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.moreRed,
        foregroundColor: ColorPalette.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.r),
        ),
      ),
      child: Text(
        "logout_button".tr(),                      // ✅ مفتاح ترجمة
        style: TextStyles.font10whitebold(),
      ),
    );
  }
}
