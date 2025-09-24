import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/language_dropdown_widget.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/data/model/local_user_model.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/data/repo/user_profile_repository.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/ui/widget/image_user_profile.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/ui/widget/profile_content_widget.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/ui/widget/user_logout_buttom.dart';
import 'package:image_picker/image_picker.dart';
import '../logic/cubit/user_profile_screen_cubit.dart';
import '../../../../core/widgets/animation_box.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: ColorPalette.mainColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                size: 18.sp,
                color: ColorPalette.textDark,
              ),
              title: Text('camera'.tr(), style: TextStyles.font12Blackbold()),
              onTap: () {
                Navigator.pop(ctx);
                context.read<UserProfileScreenCubit>().pickImage(
                      ImageSource.camera,
                    );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                size: 18.sp,
                color: ColorPalette.textDark,
              ),
              title: Text('gallery'.tr(), style: TextStyles.font12Blackbold()),
              onTap: () {
                Navigator.pop(ctx);
                context.read<UserProfileScreenCubit>().pickImage(
                      ImageSource.gallery,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileScreenCubit(UserProfileRepository())
        ..loadUserData()
        ..loadUserPhoto(),
      child: BlocConsumer<UserProfileScreenCubit, UserProfileScreenState>(
        listener: (context, state) {
          if (state is UserProfileScreenUpdating) {
            showBlockingAnimation(
              context: context,
              message: 'uploading_profile'.tr(),
              animationAsset: AppImage().loading,
            );
          } else if (state is UserProfileScreenUpdateSuccess) {
            hideBlockingAnimation(context);
            showBlockingAnimation(
              context: context,
              message: 'profile_updated'.tr(),
              animationAsset: AppImage().sucsses,
              autoClose: true,
              duration: const Duration(seconds: 3),
            );
          } else if (state is UserProfileScreenUpdateError) {
            hideBlockingAnimation(context);
            showBlockingAnimation(
              context: context,
              message: state.message,
              animationAsset: AppImage().error,
              autoClose: true,
              duration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<UserProfileScreenCubit>();
          final LocalUserModel? user = cubit.localUser;
          final File? imageFile = cubit.userImage;
          String? profilePhoto;
          if (state is UserProfilePhotoLoaded) {
            profilePhoto = state.imageUrl;
          }
          String finalImage;
          if (imageFile != null) {
            finalImage = imageFile.path;
          } else if (profilePhoto != null && profilePhoto.isNotEmpty) {
            finalImage = profilePhoto;
          } else {
            finalImage = AppImage().defultProfileAccount;
          }
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(50),
                    Center(
                      child: ImageUserProfile(
                        imageUrl: finalImage,
                        userName: user?.name ?? "loading".tr(),
                        onCameraTap: () => _showImageSourceDialog(context),
                        onEditTap: () => _showImageSourceDialog(context),
                      ),
                    ),
                    verticalSpace(35),
                    if (user != null) ProfileContentWidget(user: user),
                  ],
                ),
                Positioned(
                  top: 28.h,
                  right: 18.w,
                  child: const UserLogoutButtom(),
                ),
                 Positioned(
                  top: 28.h,
                  left: 18.w,
                  child: const LanguageDropdownWidget(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
