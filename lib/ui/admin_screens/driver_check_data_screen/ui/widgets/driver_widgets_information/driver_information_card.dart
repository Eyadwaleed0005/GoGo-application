import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverInformationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String email;
  final int age;
  final String phoneNumber;

  const DriverInformationCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.age,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imageUrl,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
              ),
            ),
            verticalSpace(15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("الاسم", style: TextStyles.font10BlackSemiBold()),
            ),
            verticalSpace(4),
            _infoBox(name),
            verticalSpace(10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("الإيميل", style: TextStyles.font10BlackSemiBold()),
            ),
            verticalSpace(4),
            _infoBox(email),
            verticalSpace(10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("العمر", style: TextStyles.font10BlackSemiBold()),
            ),
            verticalSpace(4),
            _infoBox("$age"),
            verticalSpace(10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "رقم الهاتف",
                style: TextStyles.font10BlackSemiBold(),
              ),
            ),
            verticalSpace(4),
            GestureDetector(
              onTap: () async {
                Clipboard.setData(ClipboardData(text: phoneNumber));
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    content: Center(
                      heightFactor: 1,
                      child: Text(
                        'تم نسخ رقم الهاتف',
                        style: TextStyles.font10BlackSemiBold(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
                await Future.delayed(const Duration(seconds: 1));
                if (context.mounted) Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: ColorPalette.backgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(phoneNumber, style: TextStyles.font10BlackSemiBold()),
                    Icon(Icons.copy, size: 16.sp, color: Colors.grey[700]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: ColorPalette.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(value, style: TextStyles.font10BlackSemiBold()),
    );
  }
}
