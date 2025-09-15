import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/widgets/custom_outlined_button.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 181.w,
                  height: 181.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(AppImage().onboard8, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Text(
                  'Choose Account Type',
                  style: TextStyles.font19BlackBold(),
                ),
              ),
              Center(
                child: Text(
                  'driver or a rider?',
                  style: TextStyles.font19BlackBold(),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  'Please select the account type',
                  style: TextStyles.font11GrayRegular(),
                ),
              ),
              Center(
                child: Text(
                  'that best suits your usage.',
                  style: TextStyles.font11GrayRegular(),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: CustomButton(
                  text: 'Rider',
                  backgroundColor: ColorPalette.mainColor,
                  height: 30.h,
                  width: 222.w,
                  borderRadius: 3.r,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.riderAuthScreen);
                  },
                ),
              ),
              SizedBox(height: 15.h),
              Center(
                child: CustomOutlinedButton(
                  text: 'Driver',
                  height: 30.h,
                  width: 200.w,
                  borderRadius: 3.r,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.driverAuthScreen);
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
