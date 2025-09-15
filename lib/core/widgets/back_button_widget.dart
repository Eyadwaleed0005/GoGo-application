import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:  Icon(Icons.arrow_back, color:ColorPalette.textDark, size:20.sp ,),
      onPressed: () {
        Navigator.pop(context); 
      },
    );
  }
}
