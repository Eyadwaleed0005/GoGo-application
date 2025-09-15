import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';


class NotesInputField extends StatelessWidget {
  final TextEditingController controller;

  const NotesInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Notes ",
            style: TextStyles.font15blackBold(),
          ),
        ),
        verticalSpace(8),
        TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 12.w,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  const BorderSide(color: ColorPalette.fieldStroke),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: ColorPalette.mainColor,
                width: 1.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
