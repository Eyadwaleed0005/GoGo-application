import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class DriverIdCard extends StatelessWidget {
  final String idFrontUrl;
  final String idBackUrl;
  final String nationalId;

  const DriverIdCard({
    super.key,
    required this.idFrontUrl,
    required this.idBackUrl,
    required this.nationalId,
  });

  void _openFullImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.mainColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "بطاقة الهوية",
                style: TextStyles.font15Blackbold(),
              ),
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
                        onTap: () => _openFullImage(context, idFrontUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: Image.network(
                              idFrontUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "الوجه الخلفي",
                        style: TextStyles.font15Blackbold(),
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () => _openFullImage(context, idBackUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: Image.network(
                              idBackUrl,
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
            Center(
              child: Text(
                "الرقم القومي",
                style: TextStyles.font15Blackbold(),
              ),
            ),
            verticalSpace(6),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  nationalId,
                  style: TextStyles.font15Blackbold(),
                ),
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
      backgroundColor: Colors.black,
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
