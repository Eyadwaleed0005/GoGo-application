import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({super.key});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();

  static Future<int?> show(BuildContext context) async {
    return await showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (_) => const ReviewDialog(),
    );
  }
}

class _ReviewDialogState extends State<ReviewDialog> {
  int? selectedRating;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text("driver_rating".tr(), style: TextStyles.font12Blackbold()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "select_rating_message".tr(),
            style: TextStyles.font10blackMedium(),
          ),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRating = starValue;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      size: 25.sp,
                      color: (selectedRating ?? 0) >= starValue
                          ? Colors.amber
                          : Colors.grey,
                    ),
                  ),
                  horizontalSpace(4),
                ],
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text("cancel".tr(), style: TextStyles.font10blackMedium()),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () {
            if (selectedRating == null) return;
            Navigator.pop(context, selectedRating);
          },
          child: Text("submit".tr(), style: TextStyles.font10whitebold()),
        ),
      ],
    );
  }
}
