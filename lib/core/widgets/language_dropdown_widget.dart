import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class LanguageDropdownWidget extends StatefulWidget {
  const LanguageDropdownWidget({super.key});

  @override
  State<LanguageDropdownWidget> createState() => _LanguageDropdownWidgetState();
}

class _LanguageDropdownWidgetState extends State<LanguageDropdownWidget> {
  final storage = const FlutterSecureStorage();
  String? selectedLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLang ??= context.locale.languageCode;
  }

  void _changeLanguage(String langCode) async {
    Locale newLocale = Locale(langCode);
    await context.setLocale(newLocale);
    await storage.write(key: 'selectedLanguage', value: langCode);
    setState(() {
      selectedLang = langCode;
    });
  }

  void _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorPalette.backgroundColor,
          title: Text(
            "delete_account".tr(),
            style: TextStyles.font10Blackbold(),
          ),
          content: Text(
            "delete_account_confirmation".tr(),
            style: TextStyles.font10BlackMedium(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("cancel".tr(), style: TextStyles.font8Blackbold()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.moreRed,
              ),
              child: Text("yes".tr(), style: TextStyles.font8whiteSemiBold()),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    _deleteAccount();
  }

  void _deleteAccount() async {
    final userId = await SecureStorageHelper.getdata(
      key: SecureStorageKeys.userId,
    );
    if (userId == null) return;

    try {
      await DioHelper.deleteData(url: EndPoints.deleteAccount(userId));
      await SecureStorageHelper.clearAll();
      await SharedPreferencesHelper.clearAll();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.accountTypeScreen,
        (route) => false,
      );
    } on DioException catch (_) {
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      onSelected: (value) {
        if (value == 'delete') {
          _showDeleteDialog(context);
        } else {
          _changeLanguage(value);
        }
      },
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(color: ColorPalette.backgroundColor),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en',
          child: Text("English", style: TextStyles.font10Blackbold()),
        ),
        PopupMenuItem(
          value: 'ar',
          child: Text("العربية", style: TextStyles.font10Blackbold()),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 20.sp),
              horizontalSpace(8),
              Text(
                "delete_account".tr(),
                style: TextStyles.font10Blackbold().copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
      child: Icon(Icons.settings, size: 22.sp, color: ColorPalette.black),
    );
  }
}
