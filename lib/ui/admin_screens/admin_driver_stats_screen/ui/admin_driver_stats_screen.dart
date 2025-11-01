import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/ui/admin_screens/admin_driver_stats_screen/data/repo/driver_approved_repo.dart';
import 'package:gogo/ui/admin_screens/admin_driver_stats_screen/logic/cubit/admin_driver_stats_screen_cubit.dart';
import 'package:gogo/ui/admin_screens/admin_driver_stats_screen/ui/widgets/driver_stat_card.dart';
import 'package:gogo/ui/admin_screens/admin_driver_stats_screen/ui/widgets/driver_info_card.dart';

class AdminDriverStatsScreen extends StatelessWidget {
  const AdminDriverStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdminDriverStatsScreenCubit(DriverApprovedRepo())..getAllDrivers(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("إحصائيات السواقين", style: TextStyles.font15blackBold()),
          centerTitle: true,
          backgroundColor: ColorPalette.mainColor,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 15.0.w),
          child:
              BlocBuilder<
                AdminDriverStatsScreenCubit,
                AdminDriverStatsScreenState
              >(
                builder: (context, state) {
                  if (state is AdminDriverStatsScreenLoading) {
                    return Center(
                      child: AnimationBox(
                        message: "جارِ تحميل بيانات السواقين...",
                        textStyle: TextStyles.font15Blackbold(),
                        animationAsset: AppImage().loading,
                      ),
                    );
                  }
                  if (state is AdminDriverStatsScreenError) {
                    return Center(
                      child: AnimationBox(
                        message: state.message,
                        animationAsset: AppImage().error,
                        textStyle: TextStyles.font15Blackbold(),
                      ),
                    );
                  }
                  if (state is AdminDriverStatsScreenLoaded) {
                    final drivers = state.drivers;
                    if (drivers.isEmpty) {
                      return Center(
                        child: AnimationBox(
                          message: "لا يوجد سواقين حاليًا",
                          animationAsset: AppImage().emptyBox,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 400.h,
                            child: DriverStatCard(
                              stats: {
                                "رجال": drivers
                                    .where((d) => d.gender == "male")
                                    .length,
                                "نساء": drivers
                                    .where((d) => d.gender == "female")
                                    .length,
                                "عربية": drivers
                                    .where(
                                      (d) =>
                                          d.carBrand != "taxi" &&
                                          d.carBrand != "scooter",
                                    )
                                    .length,
                                "تاكسي": drivers
                                    .where((d) => d.carBrand == "taxi")
                                    .length,
                                "إسكوتر": drivers
                                    .where((d) => d.carBrand == "scooter")
                                    .length,
                              },
                              label: "إحصائيات السواقين",
                              color: ColorPalette.mainColor,
                            ),
                          ),
                          verticalSpace(30),
                          Text(
                            "قائمة السواقين العاملين",
                            style: TextStyles.font15blackBold(),
                          ),
                          verticalSpace(15),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: drivers.length,
                            separatorBuilder: (context, index) =>
                                verticalSpace(20),
                            itemBuilder: (context, index) {
                              final driver = drivers[index];
                              return DriverInfoCard(
                                imageUrl: driver.driverPhoto.isNotEmpty
                                    ? driver.driverPhoto
                                    : "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                name: driver.driverFullname,
                                rating: driver.review,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.adminDriverInfoScreen,
                                    arguments: {
                                      'userId': driver.userId,
                                      'carPhoto': driver
                                          .carPhoto, 
                                    },
                                  );
                                },
                              );
                            },
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
