import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_login_screen.dart/ui/widgets/login_animation_widget.dart';

class AccountMethodSelectionLoginScreen extends StatelessWidget {
  const AccountMethodSelectionLoginScreen({super.key});

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
                'How would you like to login?',
                style: TextStyles.font18BlackBold(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.h),

              CustomButton(
                text: 'Login with Phone Number',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.phoneNumberLoginScreen,
                  );
                },
                borderRadius: 8.r,
              ),
              SizedBox(height: 16.h),

              CustomButton(
                text: 'Login with Email and Password',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.loginScreen);
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
