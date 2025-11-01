import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/ui/admin_screens/admin_driver_info_screen/data/repo/driver_info_screen_repo.dart';
import 'package:gogo/ui/admin_screens/admin_driver_info_screen/logic/cubit/admin_driver_info_screen_cubit.dart';
import 'package:gogo/ui/admin_screens/admin_driver_info_screen/ui/widgets/driver_info_row.dart';
import 'package:gogo/ui/admin_screens/admin_driver_info_screen/ui/widgets/driver_profile_details.dart';
import 'package:gogo/ui/admin_screens/admin_driver_info_screen/ui/widgets/driver_trip_card.dart';

class AdminDriverInfoScreen extends StatelessWidget {
  final String userId;
  final String carPhoto;

  const AdminDriverInfoScreen({
    super.key,
    required this.userId,
    required this.carPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdminDriverInfoScreenCubit(DriverInfoRepo())..loadDriverInfo(userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text("تفاصيل السائق", style: TextStyles.font15blackBold()),
          centerTitle: true,
          backgroundColor: ColorPalette.mainColor,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
          child: BlocBuilder<AdminDriverInfoScreenCubit,
              AdminDriverInfoScreenState>(
            builder: (context, state) {
              if (state is AdminDriverInfoScreenLoading) {
                return Center(
                  child: AnimationBox(
                    message: "جارِ تحميل بيانات السائق...",
                    textStyle: TextStyles.font15Blackbold(),
                    animationAsset: AppImage().loading,
                  ),
                );
              }
              if (state is AdminDriverInfoScreenError) {
                return Center(
                  child: AnimationBox(
                    message: state.message,
                    textStyle: TextStyles.font15Blackbold(),
                    animationAsset: AppImage().error,
                  ),
                );
              }
              if (state is AdminDriverInfoScreenLoaded) {
                final driver = state.driver;
                final history = state.history;
                final tripCount = history.isNotEmpty ? history.length : 0;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DriverProfileDetails(
                        imageUrl: driver.driverPhoto.isNotEmpty
                            ? driver.driverPhoto
                            : "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                        name: driver.driverFullname,
                        gender: driver.gender,
                        carBrand: driver.carBrand,
                      ),
                      verticalSpace(25),
                      DriverTripCard(
                        count: tripCount,
                        color: ColorPalette.mainColor,
                        rating: driver.review,
                      ),
                      verticalSpace(25),

                      if (carPhoto.isNotEmpty) ...[
                        Text("صورة السيارة",
                            style: TextStyles.font15Blackbold()),
                        verticalSpace(10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            carPhoto,
                            height: 220.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        verticalSpace(15),
                      ],
                      Divider(thickness: 1.w, color: ColorPalette.fieldStroke),
                      verticalSpace(10),
                      DriverInfoRow(
                        label: "رقم الهاتف",
                        value: driver.phoneNumber,
                        copyable: true,
                      ),
                      DriverInfoRow(label: "السن", value: driver.age.toString()),
                      DriverInfoRow(
                        label: "الرقم القومي",
                        value: driver.nationalId,
                      ),
                      DriverInfoRow(
                        label: "رقم الرخصة",
                        value: driver.licenseNumber,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
