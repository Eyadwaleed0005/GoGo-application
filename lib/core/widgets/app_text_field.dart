import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gogo/core/style/app_color.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double horizontalPadding;
  final String? prefixText;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.horizontalPadding = 2,
    this.prefixText,
    this.keyboardType,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding.w),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme:  TextSelectionThemeData(
            cursorColor: ColorPalette.mainColor,
            selectionColor:ColorPalette.mainColor,
            selectionHandleColor: ColorPalette.mainColor,
          ),
        ),
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: widget.isPassword ? _obscure : false,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixText: widget.prefixText,
            prefixStyle: TextStyle(
              color: ColorPalette.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 14.h,
            ),
            errorStyle: TextStyle(
              fontSize: 9.sp,
              height: 0.8.h,
              color:ColorPalette.red,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  BorderSide(color: ColorPalette.fieldStroke, width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  BorderSide(color: ColorPalette.fieldStroke, width: 1.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: ColorPalette.red, width: 1.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: ColorPalette.red, width: 1.w),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: FaIcon(
                      _obscure
                          ? FontAwesomeIcons.eyeLowVision
                          : FontAwesomeIcons.eye,
                      color: ColorPalette.fieldStroke,
                      size: 15.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
