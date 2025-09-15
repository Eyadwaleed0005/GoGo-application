import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/app_text_field.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_register_screen/logic/register_user_screen_cubit.dart';

class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterUserScreenCubit>();

    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Full Name', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'Your Name',
            controller: cubit.nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* Name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 8.h),

          Text('Email Here', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: 'your@gmail.com',
            controller: cubit.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* Email is required';
              }
              if (!value.contains('@')) {
                return '* Enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 8.h),

          // ✅ حقل التليفون
          Text('Phone Number', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: '01xxxxxxxxx',
            controller: cubit.phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* Phone number is required';
              }
              if (value.length < 10) {
                return '* Enter a valid phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 8.h),

          Text('Password', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: '*****************',
            isPassword: true,
            controller: cubit.passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* Password is required';
              }
              if (value.length < 6 || value.length > 20) {
                return '* Password must be 6-20 characters';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return '* Must contain at least 1 uppercase letter';
              }
              if (!RegExp(r'\d').hasMatch(value)) {
                return '* Must contain at least 1 number';
              }
              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(value)) {
                return '* Must contain at least 1 special character';
              }
              return null;
            },
          ),

          SizedBox(height: 8.h),

          Text('Confirm Password', style: TextStyles.font10BlackSemiBold()),
          SizedBox(height: 8.h),
          AppTextField(
            hint: '*****************',
            isPassword: true,
            controller: cubit.confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* Please confirm your password';
              }
              if (value != cubit.passwordController.text) {
                return '* Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 25.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              child: CustomButton(
                text: 'SIGN UP',
                borderRadius: 4.r,
                onPressed: () {
                  final isValid = cubit.validateForm();
                  if (!isValid) return;
                  cubit.registerUser();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
