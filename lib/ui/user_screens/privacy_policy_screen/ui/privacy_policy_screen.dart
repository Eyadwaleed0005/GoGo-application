import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/widgets/background_widget.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/textstyles.dart';

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
                        "Privacy Policy",
                       style: TextStyles.font15Blackbold()
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                    },
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
                  child: Text(
                    """1) Information We Collect

When you use GoGo, we may collect the following information:

- Account information: Name, email address, phone number (when you register).
- Location data: To identify your pickup and drop-off points and enable navigation.
- Payment information: If you choose to pay electronically via Google Play Billing or other payment providers.
- Device and usage data: Such as device type, operating system, IP address, crash logs, and app usage statistics.
- Communication data: Messages or inquiries you send to us through the app or support channels.

2) How We Use Your Information

We use your information to:

- Provide and operate ride-hailing and delivery services.
- Connect riders and drivers and enable communication between them.
- Process payments and generate trip receipts.
- Improve app performance, fix bugs, and enhance user experience.
- Send you ride updates, notifications, or promotional offers.
- Comply with legal requirements and prevent fraud.

3) Sharing Your Information

We do not sell your personal data. We may share limited data as follows:

- With drivers/riders: To enable rides, we share essential details like your name, phone number, and location.
- With service providers: Such as Google Firebase (analytics/crash reporting) or AdMob (advertising, if applicable).
- For legal reasons: If required by law, regulation, or to protect rights and safety.

4) Permissions We Request

The GOGO app may request the following permissions:

- Location (GPS): To find your location and provide ride services.
- Phone/Contacts (optional): To allow communication with drivers or riders.
- Notifications: To send alerts about ride status, arrivals, and updates.

You can manage or revoke permissions anytime from your device settings.

5) Data Retention

We retain your information for as long as your account is active or as required by law. You may request deletion of your data and account at any time by contacting us.

6) Data Security

We use appropriate technical and organizational measures to protect your personal data (including encryption and restricted access). However, no method of transmission or storage is completely secure.

7) Children’s Privacy

GOGO is not intended for individuals under the age of 18. We do not knowingly collect data from children. If we discover that a child has provided data, we will delete it immediately.

8) Your Rights

Depending on your region, you may have the right to:

- Access, correct, or delete your data.
- Withdraw consent for certain data uses (e.g., personalized ads).
- Deactivate or delete your account.

9) Changes to This Privacy Policy

We may update this Privacy Policy from time to time. Updates will be posted in the app with the revised “Last Updated” date.

10) Contact Us

If you have any questions or concerns regarding this Privacy Policy, please contact us:

Responsible entity: [GOGO/Mohamed Hassan]

Email: >>>>>
""",
                    style: TextStyles.font12Blackbold().copyWith(
                      color: Colors.white,
                    ),
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
