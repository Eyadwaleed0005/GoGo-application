import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/app_text_field.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_login_screen/logic/driver_login_screen_cubit.dart';

class DriverLoginFormFields extends StatelessWidget {
  const DriverLoginFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverLoginScreenCubit>();

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('email'.tr(), style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 7.h),
          AppTextField(
            hint: 'email_hint'.tr(),
            controller: cubit.emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'email_required'.tr()}';
              }
              return null;
            },
          ),
          SizedBox(height: 8.h),
          Text('password'.tr(), style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'password_hint'.tr(),
            isPassword: true,
            controller: cubit.passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'password_required'.tr()}';
              }
              if (value.length < 6) {
                return '* ${'password_min_length'.tr()}';
              }
              return null;
            },
          ),
          /*SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.resetPasswordScreen,
                );
              },
              child: Text(
                'forgot_password'.tr(),
                style: TextStyles.font10GreyDarkSemiBold(),
              ),
            ),
          ),*/
          SizedBox(height: 120.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              child: CustomButton(
                text: 'sign_in'.tr(),
                borderRadius: 3.r,
                onPressed: () {
                  if (cubit.validateForm()) {
                    cubit.loginUser();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
