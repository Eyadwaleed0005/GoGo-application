import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/widgets/custom_outlined_button.dart';

class RiderAuthScreen extends StatelessWidget {
  const RiderAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackTextButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  width: 181.w,
                  height: 181.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(AppImage().auth1, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Text(
                  'Move Smarter with gogo',
                  style: TextStyles.font21BlackBold(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  'Register now and enjoy safe, fast rides',
                  style: TextStyles.font11GrayRegular(),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  'whenever and wherever you need.',
                  style: TextStyles.font11GrayRegular(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: CustomButton(
                  text: 'Register',
                  backgroundColor: ColorPalette.mainColor,
                  height: 30.h,
                  width: 222.w,
                  borderRadius: 3.r,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.userRegisterScreen);
                  },
                ),
              ),
              SizedBox(height: 15.h),
              Center(
                child: CustomOutlinedButton(
                  text: 'Log in',
                  height: 30.h,
                  width: 200.w,
                  borderRadius: 3.r,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.loginScreen);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
