import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/widgets/background_widget.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/privacy_policy_screen/ui/widgets/social_icon_widget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      imagePath: AppImage().backGround2,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorPalette.textColor1,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "privacy_policy".tr(),
                        style: TextStyles.font15Blackbold(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(30.r),
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: ColorPalette.textColor1,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star_outline,
                        color: ColorPalette.backgroundColor,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(20),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "privacy_policy_content".tr(),
                        style: TextStyles.font12Blackbold().copyWith(
                          color: Colors.white,
                        ),
                      ),
                      verticalSpace(50),
                      Text(
                        "connect_with_us".tr(),
                        style: TextStyles.font15Blackbold().copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SocialIconWidget(
                            icon: Icons.email,
                            url: "mailto:gogo54369428@gmail.com",
                            color: Colors.red,
                          ),
                          SocialIconWidget(
                            icon: FontAwesomeIcons.whatsapp,
                            url: "https://wa.me/201501428192",
                            color: Colors.green,
                          ),
                          SocialIconWidget(
                            icon: FontAwesomeIcons.facebook,
                            url:
                                "https://www.facebook.com/share/1BeDH6AbH9/?mibextid=wwXIfr",
                            color: Colors.blue,
                          ),
                          SocialIconWidget(
                            icon: FontAwesomeIcons.instagram,
                            url:
                                "https://www.instagram.com/gogo___app?igsh=MXA0eThucDMzcTF1eQ==",
                            color: Colors.purple,
                          ),
                          SocialIconWidget(
                            icon: FontAwesomeIcons.tiktok,
                            url: "http://www.tiktok.com/@gogo_app24",
                            color: Colors.black,
                          ),
                          verticalSpace(100)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
