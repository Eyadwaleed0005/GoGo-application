import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/start_screens/on_boarding_screens/logic/on_boarding_cubit.dart';
import 'package:gogo/ui/start_screens/on_boarding_screens/logic/on_boarding_state.dart';
import 'package:gogo/ui/start_screens/on_boarding_screens/ui/widgets/skip_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _controller;

  late Animation<double> _fadeImage;
  late Animation<double> _fadeTitle;
  late Animation<double> _fadeDesc;
  late Animation<double> _fadeButton;

  late Animation<Offset> _slideImage;
  late Animation<Offset> _slideTitle;
  late Animation<Offset> _slideDesc;
  late Animation<Offset> _slideButton;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'onboarding1_title'.tr(),
      'description': 'onboarding1_description'.tr(),
      'image': AppImage().onboard1,
    },
    {
      'title': 'onboarding2_title'.tr(),
      'description': 'onboarding2_description'.tr(),
      'image': AppImage().onboard2,
    },
    {
      'title': 'onboarding3_title'.tr(),
      'description': 'onboarding3_description'.tr(),
      'image': AppImage().onboard3,
    },
    {
      'title': 'onboarding4_title'.tr(),
      'description': 'onboarding4_description'.tr(),
      'image': AppImage().onboard5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _fadeImage = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)),
    );
    _slideImage = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)),
    );

    _fadeTitle = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.55)),
    );
    _slideTitle = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.55)),
    );

    _fadeDesc = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.75)),
    );
    _slideDesc = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.75)),
    );

    _fadeButton = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1.0)),
    );
    _slideButton = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1.0)),
    );

    _controller.forward();
  }

  void goNext(BuildContext context, int currentPage) {
    if (currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.accountTypeScreen,
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPage(BuildContext context, int index) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _fadeImage,
            child: SlideTransition(
              position: _slideImage,
              child: Container(
                width: 181.w,
                height: 181.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.r,
                      offset: Offset(0, 5.h),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 28.h),
          FadeTransition(
            opacity: _fadeTitle,
            child: SlideTransition(
              position: _slideTitle,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  onboardingData[index]['title']!,
                  style: TextStyles.font21BlackBold(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          FadeTransition(
            opacity: _fadeDesc,
            child: SlideTransition(
              position: _slideDesc,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  onboardingData[index]['description']!,
                  style: TextStyles.font11GrayRegular(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                  (i) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    width: state.currentPage == i ? 6.w : 4.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: state.currentPage == i
                          ? ColorPalette.mainColor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SkipButton(context: context),
              Expanded(
                child: BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingData.length,
                      onPageChanged: (index) {
                        context.read<OnboardingCubit>().nextPage(index);
                      },
                      itemBuilder: (context, index) =>
                          _buildPage(context, index),
                    );
                  },
                ),
              ),
              FadeTransition(
                opacity: _fadeButton,
                child: SlideTransition(
                  position: _slideButton,
                  child: BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 45.w,
                          vertical: 30.h,
                        ),
                        child: ElevatedButton(
                          onPressed: () => goNext(context, state.currentPage),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.mainColor,
                            foregroundColor: ColorPalette.secondColor,
                            minimumSize: Size(double.infinity, 55.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'continue'.tr(),
                            style: TextStyles.font11blackMediam(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
