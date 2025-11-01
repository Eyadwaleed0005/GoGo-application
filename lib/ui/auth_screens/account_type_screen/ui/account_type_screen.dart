import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/widgets/custom_outlined_button.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _slideImage;
  late Animation<Offset> _slideText;
  late Animation<Offset> _slideRiderButton;
  late Animation<Offset> _slideDriverButton;

  late Animation<double> _fadeImage;
  late Animation<double> _fadeText;
  late Animation<double> _fadeRiderButton;
  late Animation<double> _fadeDriverButton;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // الصورة
    _slideImage = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
    ));
    _fadeImage = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3),
    ));

    // النصوص
    _slideText = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOutCubic),
    ));
    _fadeText = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.6),
    ));

    // الزر الأول Rider
    _slideRiderButton =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.8, curve: Curves.easeOutCubic),
    ));
    _fadeRiderButton = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.8),
    ));

    // الزر الثاني Driver
    _slideDriverButton =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOutCubic),
    ));
    _fadeDriverButton = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.0),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                // الصورة
                FadeTransition(
                  opacity: _fadeImage,
                  child: SlideTransition(
                    position: _slideImage,
                    child: Center(
                      child: Container(
                        width: 181.w,
                        height: 181.w,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.asset(
                            AppImage().onboard8,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // النصوص
                FadeTransition(
                  opacity: _fadeText,
                  child: SlideTransition(
                    position: _slideText,
                    child: Column(
                      children: [
                        Text(
                          'choose_account_type'.tr(),
                          style: TextStyles.font19BlackBold(),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'driver_or_rider'.tr(),
                          style: TextStyles.font19BlackBold(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'please_select_account'.tr(),
                          style: TextStyles.font11GrayRegular(),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'that_best_suits_usage'.tr(),
                          style: TextStyles.font11GrayRegular(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // الزر الأول (Rider)
                FadeTransition(
                  opacity: _fadeRiderButton,
                  child: SlideTransition(
                    position: _slideRiderButton,
                    child: Center(
                      child: CustomButton(
                        text: 'rider'.tr(),
                        backgroundColor: ColorPalette.mainColor,
                        height: 30.h,
                        width: 222.w,
                        borderRadius: 3.r,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.riderAuthScreen,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                FadeTransition(
                  opacity: _fadeDriverButton,
                  child: SlideTransition(
                    position: _slideDriverButton,
                    child: Center(
                      child: CustomOutlinedButton(
                        text: 'driver'.tr(),
                        height: 30.h,
                        width: 200.w,
                        borderRadius: 3.r,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.driverAuthScreen,
                          );
                        },
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
