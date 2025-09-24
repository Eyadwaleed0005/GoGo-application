import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/logic/cubit/user_profile_screen_cubit.dart';
import 'custom_image_card.dart';
import 'user_data_widget.dart';
import '../../data/model/local_user_model.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileContentWidget extends StatelessWidget {
  final LocalUserModel user;

  const ProfileContentWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorPalette.mainColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CustomImageCard(
                        width: 90,
                        height: 100,
                        imageWidth: 40,
                        imageHeight: 40,
                        assetImage: AppImage().masterCard,
                        title: 'payments_methods'.tr(), // مفتاح الترجمة
                        onTap: () {},
                        spaceBetweenImageAndPhoto: 0,
                        isComingSoon: true,
                      ),
                      verticalSpace(8.h),
                      CustomImageCard(
                        width: 90,
                        height: 100,
                        imageWidth: 40,
                        imageHeight: 40,
                        assetImage: AppImage().privacyPolicy,
                        title: 'privacy_policy'.tr(),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.privacyPolicyScreen,
                          );
                        },
                        spaceBetweenImageAndPhoto: 10,
                        isComingSoon: false,
                      ),
                      verticalSpace(4),
                      Text('GoGo', style: TextStyles.font25Blackbold()),
                    ],
                  ),
                  horizontalSpace(12),
                  Column(
                    children: [
                      CustomImageCard(
                        width: 100,
                        height: 50,
                        assetImage: AppImage().activity,
                        title: 'activity'.tr(),
                        onTap: () {
                          final cubit = context.read<UserProfileScreenCubit>();
                          final String? profilePhotoUrl =
                              cubit.userProfileImageUrl;
                          Navigator.pushNamed(
                            context,
                            AppRoutes.userHistoryScreen,
                            arguments: profilePhotoUrl,
                          );
                        },
                        imageWidth: 45,
                        imageHeight: 25,
                        spaceBetweenImageAndPhoto: 0,
                        isComingSoon: false,
                      ),
                      verticalSpace(12),
                      UserDataWidget(
                        userName: user.name,
                        userEmail: user.email,
                        userPhone: user.phone,
                        width: 130,
                        height: 190,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
