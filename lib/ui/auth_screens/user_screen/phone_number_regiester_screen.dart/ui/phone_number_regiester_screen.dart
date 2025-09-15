import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_login_screen.dart/ui/widgets/login_animation_widget.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_regiester_screen.dart/logic/cubit/phonenumberscreen_cubit.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_regiester_screen.dart/ui/widgets/phone_input_widget_regiester.dart';

class PhoneNumberRegisterScreen extends StatelessWidget {
  const PhoneNumberRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhonenumberscreenCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackTextButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                  const LoginAnimationWidget(),
                  Text(
                    'Enter your phone number',
                    style: TextStyles.font18BlackBold(),
                  ),
                  PhoneInputWidget(
                    onValidSubmit: (phone, password) {
                      print("Register Phone: $phone");
                      print("Register Password: $password");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
