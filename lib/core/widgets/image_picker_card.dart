import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class ImagePickerCard extends StatelessWidget {
  final String label;
  final File? image;
  final Function(ImageSource) onPick;
  final bool isError;

  const ImagePickerCard({
    required this.label,
    required this.image,
    required this.onPick,
    this.isError = false,
    super.key,
  });

  void _showPickOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
                title: Text(
                  "take_photo".tr(),
                  style: TextStyles.font10Blackbold(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onPick(ImageSource.camera);
                },
              ),
              Divider(thickness: 1, height: 1, color: ColorPalette.fieldStroke),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: Text(
                  "choose_from_gallery".tr(),
                  style: TextStyles.font10Blackbold(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onPick(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => _showPickOptions(context),
          child: Container(
            height: 80.h,
            width: 75.h,
            decoration: BoxDecoration(
              color: ColorPalette.backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isError ? Colors.red : ColorPalette.fieldStroke,
                width: 2.w,
              ),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(image!, fit: BoxFit.cover),
                  )
                : Center(
                    child: Icon(
                      Icons.add,
                      color: isError ? Colors.red : ColorPalette.textColor1,
                      size: 20.sp,
                    ),
                  ),
          ),
        ),
        verticalSpace(5),
        SizedBox(
          height: 40.h,
          child: Center(
            child: Text(
              label,
              style: TextStyles.font12Blackbold(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
