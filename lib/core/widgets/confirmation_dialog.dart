import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/style/app_color.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final VoidCallback onConfirm;
  final String? content;
  final bool showCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.confirmText,
    required this.onConfirm,
    this.content,
    this.showCancel = false, // ✅ الافتراضي مفيش زرار إلغاء
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        title,
        style: TextStyles.font12Blackbold(),
      ),
      content: content != null
          ? Text(content!, style: TextStyles.font10Blackbold())
          : SizedBox(height: 10.h),
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      actions: [
        if (showCancel) 
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: ColorPalette.textDark,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "cancel",
              style: TextStyles.font12BlackSemiBold(),
            ),
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.mainColor,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmText,
            style: TextStyle(fontSize: 16.sp, color: ColorPalette.textLight),
          ),
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String confirmText,
    required VoidCallback onConfirm,
    String? content,
    bool showCancel = false, 
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        confirmText: confirmText,
        onConfirm: onConfirm,
        content: content,
        showCancel: showCancel,
      ),
    );

    if (result == true) {
      onConfirm();
    }
  }
}
