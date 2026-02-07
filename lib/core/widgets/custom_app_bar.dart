import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: ColorPalette.textColor1,
            size: 20.sp,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer(); 
          },
        ),
      ),
      title: Text(
        title,
        style: TextStyles.font18BlackBold(),
      ),
      centerTitle: true,
      backgroundColor: ColorPalette.backgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
