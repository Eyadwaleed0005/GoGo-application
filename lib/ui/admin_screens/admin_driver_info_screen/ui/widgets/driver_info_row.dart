import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable; 

  const DriverInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.copyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.font12GrayRegular()),
          Row(
            children: [
              Text(
                value,
                style: TextStyles.font12Blackbold(),
              ),
              if (copyable) ...[
                horizontalSpace(6),
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: value));
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierLabel: "",
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              margin: EdgeInsets.only(top: 100.h),
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "تم نسخ رقم الهاتف ",
                                style: TextStyles.font10whitebold()
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Icon(Icons.copy, size: 18.sp, color: ColorPalette.fieldStroke),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
