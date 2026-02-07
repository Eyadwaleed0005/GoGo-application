import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/widgets/app_text_field.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/auth_screens/user_screen/reset_passoword_screen/logic/reset_password_cubit.dart';

class ResetPasswordFormFields extends StatelessWidget {
  const ResetPasswordFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetPasswordCubit>();
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Password', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: '*****************',
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
          SizedBox(height: 15.h),
          Text('Confirm Password', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: '*****************',
            isPassword: true,
            controller: cubit.confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* Confirm password is required';
              }
              if (value != cubit.passwordController.text) {
                return '* Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 14.h),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyles.font10GreyDarkSemiBold(),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Center(
            child: CustomButton(
              text: 'SUBMIT',
              borderRadius: 4.r,
              onPressed: () {
                final isValid = context
                    .read<ResetPasswordCubit>()
                    .validateForm();
                if (!isValid) return;
              },
            ),
          ),
        ],
      ),
    );
  }
}
