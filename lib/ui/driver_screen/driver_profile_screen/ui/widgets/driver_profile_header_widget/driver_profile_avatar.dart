import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/logic/cubit/driver_profile_screen_cubit.dart';

class DriverProfileAvatar extends StatelessWidget {
  final double radius;
  final Color borderColor;
  final double borderWidth;

  const DriverProfileAvatar({
    super.key,
    this.radius = 45,
    this.borderColor = ColorPalette.mainColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverProfileScreenCubit, DriverProfileScreenState>(
      builder: (context, state) {
        String imageToDisplay = AppImage().defultProfileAccount;
        if (state is DriverProfileScreenLoaded) {
          if (state.driverProfile.driverPhoto.isNotEmpty) {
            imageToDisplay = state.driverProfile.driverPhoto;
          }
        }
        final isNetworkImage =
            imageToDisplay != AppImage().defultProfileAccount;

        return Container(
          width: radius.r * 2,
          height: radius.r * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPalette.circlesBackground,
            border: !isNetworkImage
                ? Border.all(color: borderColor, width: borderWidth.w)
                : null,
          ),
          child: ClipOval(
            child: isNetworkImage
                ? Image.network(
                    imageToDisplay,
                    width: radius.r * 2,
                    height: radius.r * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImage().defultProfileAccount,
                        width: radius.r * 2,
                        height: radius.r * 2,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    AppImage().defultProfileAccount,
                    width: radius.r * 2,
                    height: radius.r * 2,
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }
}
