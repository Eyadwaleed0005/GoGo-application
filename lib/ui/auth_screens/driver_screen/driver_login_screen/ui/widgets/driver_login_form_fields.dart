import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_routes.dart';
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
          Text('Email or Phone', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 7.h),
          AppTextField(
            hint: 'your@gmail.com or phone number',
            controller: cubit.emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* Email or Phone is required';
              }
              // لو ايميل مش لازم يتحقق من @، لكن لو عايز تضيف شرط ممكن
              return null;
            },
          ),
          SizedBox(height: 8.h),
          Text('Password', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'Enter your password',
            isPassword: true,
            controller: cubit.passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* Password is required';
              }
              if (value.length < 6) {
                return '* Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
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
                'Forgot Password?',
                style: TextStyles.font10GreyDarkSemiBold(),
              ),
            ),
          ),
          SizedBox(height: 21.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              child: CustomButton(
                text: 'SIGN IN',
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
