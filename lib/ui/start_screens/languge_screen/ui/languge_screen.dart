import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/widgets/custom_outlined_button.dart';
import 'package:gogo/ui/start_screens/languge_screen/ui/widgets/circular_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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
                  'select_language'.tr(),
                  style: TextStyles.font21BlackBold(),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  'choose_language'.tr(),
                  style: TextStyles.font11GrayRegular(),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: CustomButton(
                  text: 'english'.tr(),
                  backgroundColor: ColorPalette.mainColor,
                  height: 30.h,
                  width: 222.w,
                  borderRadius: 3.r,
                  onPressed: () async {
                    await storage.write(key: SharedPreferenceKeys.selectedLanguage, value: 'en');
                    context.setLocale(const Locale('en'));
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
                  text: 'arabic'.tr(),
                  height: 30.h,
                  width: 200.w,
                  borderRadius: 3.r,
                  onPressed: () async {
                    await storage.write(key: SharedPreferenceKeys.selectedLanguage, value: 'ar');
                    context.setLocale(const Locale('ar'));
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
