import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class UserLogoutButtom extends StatelessWidget {
  const UserLogoutButtom({super.key});

  Future<void> _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: SecureStorageKeys.token);
    await storage.delete(key: SecureStorageKeys.userType);
    await SharedPreferencesHelper.removeData(key: SharedPreferenceKeys.statusOfAccountDriver);
    await SharedPreferencesHelper.removeData(key: SharedPreferenceKeys.driverCompleteRegister);
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
          title: Text("confirm_logout".tr(), style: TextStyles.font10Blackbold()),
          content: Text("logout_confirmation".tr(), style: TextStyles.font10BlackMedium()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel".tr(), style: TextStyles.font8Blackbold()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.moreRed,
              ),
              child: Text("yes".tr(), style: TextStyles.font8whiteSemiBold()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.logout,
            color: ColorPalette.moreRed, 
            size: 22.sp,
          ),
          Text(
            "log_out".tr(),
            style: TextStyles.font8redSemiBold(), 
          ),
        ],
      ),
    );
  }
}
