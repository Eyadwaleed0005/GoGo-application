import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:intl/intl.dart';

class DriverLicenses extends StatelessWidget {
  final String licenseFrontUrl;
  final String licenseBackUrl;
  final String licenseNumber;
  final String licenseExpiryDate;

  const DriverLicenses({
    super.key,
    required this.licenseFrontUrl,
    required this.licenseBackUrl,
    required this.licenseNumber,
    required this.licenseExpiryDate,
  });

 String _formatDate(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime); 
  } catch (e) {
    return dateString;
  }
}


  void _openFullImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FullScreenImage(imageUrl: imageUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("رخصة القيادة", style: TextStyles.font15Blackbold()),
            ),
            verticalSpace(12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "الوجه الأمامي",
                        style: TextStyles.font15Blackbold(),
                      ),
                      verticalSpace(8),
                      GestureDetector(
                        onTap: () => _openFullImage(context, licenseFrontUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: Image.network(
                              licenseFrontUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    children: [
                      Text("الوجه الخلفي", style: TextStyles.font15Blackbold()),
                      verticalSpace(8),
                      GestureDetector(
                        onTap: () => _openFullImage(context, licenseBackUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: Image.network(
                              licenseBackUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            verticalSpace(20),
            Text("رقم الرخصة", style: TextStyles.font10BlackSemiBold()),
            verticalSpace(4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                licenseNumber,
                style: TextStyles.font10BlackSemiBold(),
              ),
            ),
            verticalSpace(12),
            Text("تاريخ الانتهاء", style: TextStyles.font10BlackSemiBold()),
            verticalSpace(4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: ColorPalette.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                _formatDate(licenseExpiryDate),
                style: TextStyles.font10redSemiBold(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(child: InteractiveViewer(child: Image.network(imageUrl))),
      ),
    );
  }
}
