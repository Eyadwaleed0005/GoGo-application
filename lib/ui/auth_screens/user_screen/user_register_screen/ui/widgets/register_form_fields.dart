import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/app_text_field.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_register_screen/logic/register_user_screen_cubit.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_register_screen/logic/register_user_screen_state.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_register_screen/ui/widgets/app_dropdown_gender_field.dart';

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
          Text('full_name'.tr(), style: TextStyles.font10BlackSemiBold()),
          verticalSpace(8),
          AppTextField(
            hint: 'your_name'.tr(),
            controller: cubit.nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'name_required'.tr()}';
              }
              return null;
            },
          ),
          verticalSpace(8),
          Text('email_here'.tr(), style: TextStyles.font10BlackSemiBold()),
          verticalSpace(8),
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
          verticalSpace(8),
          Text('phone_number'.tr(), style: TextStyles.font10BlackSemiBold()),
          verticalSpace(8),
          AppTextField(
            hint: 'phone_hint'.tr(),
            controller: cubit.phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '* ${'phone_required'.tr()}';
              }
              final isNumeric = RegExp(r'^[0-9]+$').hasMatch(value);
              if (!isNumeric) {
                return '* ${'phone_digits_only'.tr()}';
              }
              if (value.length != 11) {
                return '* ${'phone_11_digits'.tr()}';
              }
              if (!value.startsWith('01')) {
                return '* ${'phone_starts_01'.tr()}';
              }
              return null;
            },
          ),

          verticalSpace(8),
          Text('select_gender'.tr(), style: TextStyles.font10BlackSemiBold()),
          verticalSpace(8),
          BlocBuilder<RegisterUserScreenCubit, RegisterUserScreenState>(
            buildWhen: (previous, current) =>
                current is RegisterUserGenderChanged ||
                current is RegisterUserInitial,
            builder: (context, state) {
              return AppDropdownGenderField(
                hint: 'select_gender'.tr(),
                value: cubit.selectedGender,
                onChanged: (value) {
                  if (value != null) {
                    cubit.changeGender(value);
                  }
                },
              );
            },
          ),
          verticalSpace(8),
          Text('password'.tr(), style: TextStyles.font10BlackSemiBold()),
          verticalSpace(8),
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
              if (!RegExp(r'[a-z]').hasMatch(value)) {
                return '* ${'password_lowercase'.tr()}';
              }
              if (!RegExp(r'\d').hasMatch(value)) {
                return '* ${'password_number'.tr()}';
              }
              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(value)) {
                return '* ${'password_special'.tr()}';
              }
              if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                return '* ${'password_letter'.tr()}';
              }
              return null;
            },
          ),
          verticalSpace(8),

          Text(
            'confirm_password'.tr(),
            style: TextStyles.font10BlackSemiBold(),
          ),
          verticalSpace(8),
          AppTextField(
            hint: 'password_hint'.tr(),
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
          verticalSpace(25),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              child: CustomButton(
                text: 'sign_up'.tr(),
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
