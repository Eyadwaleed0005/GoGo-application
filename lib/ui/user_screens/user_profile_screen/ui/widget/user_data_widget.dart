import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/textstyles.dart';

class UserDataWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userPhone;
  final double width;  // عرض الكونتينر الخارجي
  final double height; // ارتفاع الكونتينر الخارجي

  const UserDataWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      padding: EdgeInsets.symmetric(vertical:3.h,horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text('Personal',style: TextStyles.font10Blackbold(),)),
          Center(child: Text('Information',style: TextStyles.font10Blackbold(),)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                userName,
                style: TextStyles.font10Blackbold(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                userEmail,
                style: TextStyles.font8Blackbold(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                userPhone,
                style: TextStyles.font10Blackbold(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
