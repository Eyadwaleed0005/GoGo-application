import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.black,
      appBar: AppBar(
        backgroundColor: ColorPalette.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color:ColorPalette.mainColor),
          onPressed: () => Navigator.pop(context), 
        ),
      ),
      body: Center(
        child: Image.asset(
          AppImage().commingSoon,
          width: 150.w,
          height: 150.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
