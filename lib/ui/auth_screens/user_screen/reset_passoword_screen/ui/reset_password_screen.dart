import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/orange_dot.dart';
import 'package:gogo/ui/auth_screens/user_screen/reset_passoword_screen/logic/reset_password_cubit.dart';
import 'package:gogo/ui/auth_screens/user_screen/reset_passoword_screen/ui/widgets/reset_password_form_fields.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackTextButton(onTap: () => Navigator.pop(context)),
                  SizedBox(height: 15.h),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Reset Password',
                          style: TextStyles.font21BlackBold(),
                        ),
                        SizedBox(width: 5.w),
                        Transform.translate(
                          offset: Offset(0, 8.h),
                          child: const OrangeDot(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Lorem ipsum dolor sit amet a ',
                          style: TextStyles.font11GrayRegular(),
                        ),
                        Text(
                          'aconsectetur ut',
                          style: TextStyles.font11GrayRegular(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  const ResetPasswordFormFields(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
