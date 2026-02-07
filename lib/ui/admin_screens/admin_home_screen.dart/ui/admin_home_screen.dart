import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الصفحة الرئيسية للإدمن",
          style: TextStyles.font15blackBold(),
        ),
        centerTitle: true,
        backgroundColor: ColorPalette.mainColor,
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAdminButton(
                  context,
                  icon: Icons.local_shipping,
                  label: "طلبات السواقين",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.driverWatingListScreen,
                    );
                  },
                ),
                _buildAdminButton(
                  context,
                  icon: Icons.payment,
                  label: "طلبات دفع السواقين",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.driverRequestChargeScreen,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color:ColorPalette.mainColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding:  EdgeInsets.all(20.w),
            child: Icon(icon, size: 30.sp, color:ColorPalette.textDark),
          ),
          verticalSpace(10),
          Text(
            label,
            style: TextStyles.font12Blackbold(),
          ),
        ],
      ),
    );
  }
}
