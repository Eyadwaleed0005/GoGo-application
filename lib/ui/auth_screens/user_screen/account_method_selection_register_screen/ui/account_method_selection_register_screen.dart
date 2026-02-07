import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_login_screen.dart/ui/widgets/login_animation_widget.dart';

class AccountMethodSelectionRegisterScreen extends StatelessWidget {
  const AccountMethodSelectionRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BackTextButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 25.h),
              LoginAnimationWidget(animationPath: AppImage().adriver),
              SizedBox(height: 12.h),
              Text(
                'How would you like to create your account?',
                style: TextStyles.font18BlackBold(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.h),
              CustomButton(
                text: 'Create Account with Phone',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.phoneNumberRegisterScreen,
                  );
                },
                borderRadius: 8.r,
              ),
              SizedBox(height: 16.h),
              CustomButton(
                text: 'Create Account with Email',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.userRegisterScreen);
                },
                borderRadius: 8.r,
                backgroundColor: ColorPalette.buttons,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
