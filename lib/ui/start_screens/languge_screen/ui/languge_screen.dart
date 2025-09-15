import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/widgets/custom_outlined_button.dart';
import 'package:gogo/ui/start_screens/languge_screen/ui/widgets/circular_image_widget.dart';


class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: CircularImageWidget(imagePath: AppImage().language),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Text(
                  'Select Language',
                  style: TextStyles.font21BlackBold(),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  'اختر اللغة',
                  style: TextStyles.font11GrayRegular(),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: CustomButton(
                  text: 'English',
                  backgroundColor: ColorPalette.mainColor,
                  height: 30.h,
                  width: 222.w,
                  borderRadius: 3.r,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.onboardingScreens,
                      (route) => false,
                    );
                  },
                ),
              ),
              SizedBox(height: 15.h),
              Center(
                child: CustomOutlinedButton(
                  text: 'العربية',
                  height: 30.h,
                  width: 200.w,
                  borderRadius: 3.r,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.onboardingScreens,
                      (route) => false,
                    );
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
