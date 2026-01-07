import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class CarLicensesCard extends StatelessWidget {
  final String licenseFrontUrl;
  final String licenseBackUrl;

  const CarLicensesCard({
    super.key,
    required this.licenseFrontUrl,
    required this.licenseBackUrl,
  });

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
              child: Text("رخصة السيارة", style: TextStyles.font15Blackbold()),
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
                      Text(
                        "الوجه الخلفي",
                        style: TextStyles.font15Blackbold(),
                      ),
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
        child: Center(
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
