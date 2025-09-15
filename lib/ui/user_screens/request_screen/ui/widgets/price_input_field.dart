import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class PriceInputField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const PriceInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 📝 العنوان
        Text(
          "Price",
          style: TextStyles.font15blackBold(),
        ),

        SizedBox(width: 12.w),

        // 💰 الفيلد بعرض أصغر
        Container(
          width: 120.w, // 👈 عرض ثابت أصغر
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyles.font15blackBold(),
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 8.w,
              ),
              prefixText: "E£ ",
              prefixStyle: TextStyles.font15blackBold(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: ColorPalette.fieldStroke,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: ColorPalette.mainColor,
                  width: 1.2.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
