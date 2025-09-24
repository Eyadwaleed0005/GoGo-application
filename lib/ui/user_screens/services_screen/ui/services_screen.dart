import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/background_widget.dart';
import 'package:gogo/ui/user_screens/home_screen/ui/widgets/pickup_point_widget.dart';
import 'package:gogo/ui/user_screens/home_screen/ui/widgets/suggestions_icons.dart';
import 'package:gogo/ui/user_screens/services_screen/ui/widgets/food_coming_soon.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      imagePath: AppImage().backGround2,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    AppImage().servises,
                    width: 35.w,
                    height: 35.w,
                    fit: BoxFit.contain,
                  ),
                  horizontalSpace(35),
                  Text(
                    'services'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyles.font20Blackbold(),
                  ),
                ],
              ),
              verticalSpace(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SuggestionsIcons(
                    imagePath: AppImage().taxiIcon,
                    label: 'car'.tr(),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.mapScreen);
                    },
                  ),
                  SuggestionsIcons(
                    imagePath: AppImage().delivery,
                    label: 'delivery'.tr(),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.mapScreen);
                    },
                  ),
                  SuggestionsIcons(
                    imagePath: AppImage().busIcon,
                    label: 'bus'.tr(),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.comingSoonScreen);
                    },
                  ),
                  SuggestionsIcons(
                    imagePath: AppImage().calendar,
                    label: 'reserve'.tr(),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.comingSoonScreen);
                    },
                  ),
                ],
              ),
              verticalSpace(12),
              FoodComingSoon(),
              verticalSpace(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImage().bannar2,
                    width: 130.w,
                    height: 130.w,
                    fit: BoxFit.contain,
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyles.font15whitebold(),
                        children: [
                          TextSpan(text: 'get_best'.tr()),
                          TextSpan(
                            text: 'bus_rides'.tr(),
                            style: TextStyles.font12Blackbold().copyWith(
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(text: 'to_destination'.tr()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("GoGo", style: TextStyles.font25Blackbold()),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.privacyPolicyScreen,
                      );
                    },
                    borderRadius: BorderRadius.circular(30.r),
                    child: Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: ColorPalette.textColor1,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star_outline,
                        size: 28.sp,
                        color: ColorPalette.mainColor,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(10),
              PickupPointWidget(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.mapScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
