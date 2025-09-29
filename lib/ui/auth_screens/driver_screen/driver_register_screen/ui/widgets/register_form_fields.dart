import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/app_text_field.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/logic/driver_register_screen_cubit.dart';

class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverRegisterScreenCubit>();

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('full_name'.tr(), style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'enter_name'.tr(),
            controller: cubit.nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'name_required'.tr()}';
              }
              return null;
            },
          ),
          SizedBox(height: 8.h),

          Text('email'.tr(), style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'enter_email'.tr(),
            controller: cubit.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'email_required'.tr()}';
              }
              if (!value.contains('@')) {
                return '* ${'valid_email'.tr()}';
              }
              if (value.split('@').length != 2) {
                return '* ${'valid_email_2'.tr()}';
              }
              return null;
            },
          ),

          SizedBox(height: 8.h),

          Text('phone_number'.tr(), style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'enter_phone'.tr(),
            controller: cubit.phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'phone_required'.tr()}';
              }
              final isNumeric = RegExp(r'^[0-9]+$').hasMatch(value);
              if (!isNumeric) {
                return '* ${'digits_only'.tr()}';
              }
              if (value.length != 11) {
                return '* ${'exact_11_digits'.tr()}';
              }
              if (!value.startsWith('01')) {
                return '* ${'start_with_01'.tr()}';
              }
              return null;
            },
          ),
          SizedBox(height: 8.h),

          Text('password'.tr(), style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'enter_password'.tr(),
            isPassword: true,
            controller: cubit.passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'password_required'.tr()}';
              }
              if (value.length < 6 || value.length > 20) {
                return '* ${'password_length'.tr()}';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return '* ${'password_uppercase'.tr()}';
              }
              if (!RegExp(r'\d').hasMatch(value)) {
                return '* ${'password_number'.tr()}';
              }
              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(value)) {
                return '* ${'password_special'.tr()}';
              }
              if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                return '* ${'password_letter'.tr()}'; // شرط الحروف العادية
              }
              return null;
            },
          ),

          SizedBox(height: 8.h),

          Text(
            'confirm_password'.tr(),
            style: TextStyles.font10BlackSemiBold(),
          ),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'confirm_password_hint'.tr(),
            isPassword: true,
            controller: cubit.confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'confirm_password_required'.tr()}';
              }
              if (value != cubit.passwordController.text) {
                return '* ${'passwords_do_not_match'.tr()}';
              }
              return null;
            },
          ),
          SizedBox(height: 25.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              child: CustomButton(
                text: 'sign_up'.tr(),
                borderRadius: 4.r,
                onPressed: () {
                  final isValid = cubit.validateForm();
                  if (!isValid) return;
                  cubit.registerDriver();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
