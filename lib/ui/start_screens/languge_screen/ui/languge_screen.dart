import 'package:easy_localization/easy_localization.dart';
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

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with TickerProviderStateMixin {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  late AnimationController _controller;
  late Animation<Offset> _slideImage;
  late Animation<Offset> _slideTitle;
  late Animation<Offset> _slideButton1;
  late Animation<Offset> _slideButton2;
  late Animation<double> _fadeImage;
  late Animation<double> _fadeTitle;
  late Animation<double> _fadeButton1;
  late Animation<double> _fadeButton2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // 🔹 الصورة
    _slideImage = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic)),
    );
    _fadeImage = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)),
    );

    // 🔹 العنوان
    _slideTitle = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic)),
    );
    _fadeTitle = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.6)),
    );

    // 🔹 زرار English
    _slideButton1 = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic)),
    );
    _fadeButton1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8)),
    );

    // 🔹 زرار Arabic
    _slideButton2 = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic)),
    );
    _fadeButton2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _setLanguageAndNavigate(BuildContext context, String langCode) async {
    await storage.write(
      key: SharedPreferenceKeys.selectedLanguage,
      value: langCode,
    );
    context.setLocale(Locale(langCode));
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.onboardingScreens,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),

                // 🌀 الصورة
                FadeTransition(
                  opacity: _fadeImage,
                  child: SlideTransition(
                    position: _slideImage,
                    child: Center(
                      child: CircularImageWidget(imagePath: AppImage().language),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // 🌀 العناوين
                FadeTransition(
                  opacity: _fadeTitle,
                  child: SlideTransition(
                    position: _slideTitle,
                    child: Column(
                      children: [
                        Text(
                          'select_language'.tr(),
                          style: TextStyles.font21BlackBold(),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'choose_language'.tr(),
                          style: TextStyles.font11GrayRegular(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // 🌀 زرار English (يظهر أول)
                FadeTransition(
                  opacity: _fadeButton1,
                  child: SlideTransition(
                    position: _slideButton1,
                    child: Center(
                      child: CustomButton(
                        text: 'english'.tr(),
                        backgroundColor: ColorPalette.mainColor,
                        height: 30.h,
                        width: 222.w,
                        borderRadius: 3.r,
                        onPressed: () => _setLanguageAndNavigate(context, 'en'),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15.h),
                FadeTransition(
                  opacity: _fadeButton2,
                  child: SlideTransition(
                    position: _slideButton2,
                    child: Center(
                      child: CustomOutlinedButton(
                        text: 'arabic'.tr(),
                        height: 30.h,
                        width: 200.w,
                        borderRadius: 3.r,
                        onPressed: () => _setLanguageAndNavigate(context, 'ar'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
