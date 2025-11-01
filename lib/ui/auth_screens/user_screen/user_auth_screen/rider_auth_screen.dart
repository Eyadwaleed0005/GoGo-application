import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/core/widgets/custom_outlined_button.dart';

class RiderAuthScreen extends StatefulWidget {
  const RiderAuthScreen({super.key});

  @override
  State<RiderAuthScreen> createState() => _RiderAuthScreenState();
}

class _RiderAuthScreenState extends State<RiderAuthScreen>
  with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideImage;
  late Animation<Offset> _slideText;
  late Animation<Offset> _slideRegisterButton;
  late Animation<Offset> _slideLoginButton;
  late Animation<double> _fadeImage;
  late Animation<double> _fadeText;
  late Animation<double> _fadeRegisterButton;
  late Animation<double> _fadeLoginButton;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1700));
    _slideImage = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
    ));
    _fadeImage = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3),
    ));
    _slideText = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOutCubic),
    ));
    _fadeText = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.6),
    ));
    _slideRegisterButton =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.8, curve: Curves.easeOutCubic),
    ));
    _fadeRegisterButton = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.8)),
    );
    _slideLoginButton =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOutCubic),
    ));
    _fadeLoginButton = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1.0)),
    );
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackTextButton(onTap: () => Navigator.pop(context)),
                SizedBox(height: 20.h),
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
                          child: Image.asset(AppImage().auth1, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                FadeTransition(
                  opacity: _fadeText,
                  child: SlideTransition(
                    position: _slideText,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'move_smarter'.tr(),
                            style: TextStyles.font21BlackBold(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: Text(
                            'register_now_enjoy'.tr(),
                            style: TextStyles.font11GrayRegular(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: Text(
                            'whenever_wherever'.tr(),
                            style: TextStyles.font11GrayRegular(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                FadeTransition(
                  opacity: _fadeRegisterButton,
                  child: SlideTransition(
                    position: _slideRegisterButton,
                    child: Center(
                      child: CustomButton(
                        text: 'register'.tr(),
                        backgroundColor: ColorPalette.mainColor,
                        height: 30.h,
                        width: 222.w,
                        borderRadius: 3.r,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.userRegisterScreen,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                FadeTransition(
                  opacity: _fadeLoginButton,
                  child: SlideTransition(
                    position: _slideLoginButton,
                    child: Center(
                      child: CustomOutlinedButton(
                        text: 'login'.tr(),
                        height: 30.h,
                        width: 200.w,
                        borderRadius: 3.r,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.loginScreen,
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
