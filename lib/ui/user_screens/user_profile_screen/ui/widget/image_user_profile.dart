import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
 //import 'package:easy_localization/easy_localization.dart';

class ImageUserProfile extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final VoidCallback? onCameraTap;
  final VoidCallback? onEditTap;

  const ImageUserProfile({
    super.key,
    required this.imageUrl,
    required this.userName,
    this.onCameraTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget _buildImage() {
      if (imageUrl.startsWith("assets/")) {
        return Image.asset(
          imageUrl,
          width: 100.r,
          height: 100.r,
          fit: BoxFit.cover,
        );
      }

      if (imageUrl.startsWith("/") || imageUrl.contains("file://")) {
        return Image.file(
          File(imageUrl),
          width: 100.r,
          height: 100.r,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              AppImage().defultProfileAccount,
              width: 100.r,
              height: 100.r,
              fit: BoxFit.cover,
            );
          },
        );
      }

      return Image.network(
        imageUrl,
        width: 100.r,
        height: 100.r,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppImage().defultProfileAccount,
            width: 100.r,
            height: 100.r,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            ClipOval(child: _buildImage()),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onCameraTap,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: ColorPalette.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: ColorPalette.textColor1,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(5.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*GestureDetector(
              onTap: onEditTap,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: ColorPalette.mainColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text('edit'.tr(), style: TextStyles.font8Blackbold()), 
              ),
            ),
            horizontalSpace(8.w),*/
            Center(child: Text(userName, style: TextStyles.font10Blackbold())),
            horizontalSpace(8.w),
          ],
        ),
      ],
    );
  }
}
