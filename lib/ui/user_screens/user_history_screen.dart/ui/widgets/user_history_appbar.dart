import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:easy_localization/easy_localization.dart';

class UserHistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? profileImageUrl; 

  const UserHistoryAppBar({super.key, this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider = (profileImageUrl != null && profileImageUrl!.isNotEmpty)
        ? NetworkImage(profileImageUrl!)
        : AssetImage(AppImage().defultProfileAccount);

    return AppBar(
      backgroundColor: ColorPalette.mainColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'activity'.tr(), 
        style: TextStyles.font10Blackbold(),
      ),
      actions: [
        Padding(
          padding:  EdgeInsets.only(left: 20.0.h),
          child: CircleAvatar(
            backgroundImage: imageProvider,
            radius: 15.r,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
