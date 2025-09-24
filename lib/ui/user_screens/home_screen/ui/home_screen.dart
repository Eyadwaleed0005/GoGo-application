import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/ho_nav_bar.dart';
import 'package:gogo/ui/user_screens/home_screen/ui/widgets/pickup_point_widget.dart';
import 'package:gogo/ui/user_screens/home_screen/ui/widgets/suggestions_icons.dart';
import 'package:gogo/ui/user_screens/services_screen/ui/services_screen.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/ui/user_profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SingleChildScrollView(child: HomeContent()),
    const ServicesScreen(),
    const UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // استدعاء البيرمشن أول ما الشاشة تتبني
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      var result = await Permission.location.request();
      if (result.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: HoNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppImage().backGround1, fit: BoxFit.cover),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("GoGo".tr(), style: TextStyles.font25MainColorbold()),
                verticalSpace(10),
                PickupPointWidget(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.mapScreen);
                  },
                ),
                verticalSpace(15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 150.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      image: DecorationImage(
                        image: AssetImage(AppImage().bannar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                verticalSpace(20),
                Text("Suggestions".tr(), style: TextStyles.font15Blackbold()),
                verticalSpace(13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SuggestionsIcons(
                      imagePath: AppImage().taxiIcon,
                      label: 'Car'.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.mapScreen);
                      },
                    ),
                    SuggestionsIcons(
                      imagePath: AppImage().delivery,
                      label: 'Delivery'.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.mapScreen);
                      },
                    ),
                    SuggestionsIcons(
                      imagePath: AppImage().busIcon,
                      label: 'Bus'.tr(),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.comingSoonScreen,
                        );
                      },
                    ),
                    SuggestionsIcons(
                      imagePath: AppImage().calendar,
                      label: 'Reserve'.tr(),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.comingSoonScreen,
                        );
                      },
                    ),
                  ],
                ),
                verticalSpace(30),
                Text(
                  "What do we offer you?".tr(),
                  style: TextStyles.font20whitebold(),
                ),
                verticalSpace(20),
                Column(
                  children: [
                    buildTimelineItem("Safe trip from start to finish.".tr()),
                    buildTimelineItem("Quick access to your destination.".tr()),
                    buildTimelineItem("Fast and efficient service.".tr()),
                    buildTimelineItem(
                      "Ease of communication between the driver and the customer."
                          .tr(),
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTimelineItem(String text, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(width: 2.w, height: 20.h, color: Colors.white),
              ],
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(text, style: TextStyles.font12whitebold()),
              ),
            ),
          ],
        ),
        if (isLast)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                AppImage().taxiIcon,
                width: 120.w,
                height: 120.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
      ],
    );
  }
}
