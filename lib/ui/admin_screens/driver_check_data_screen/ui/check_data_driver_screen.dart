import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/data/repo/driver_car_repository.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/data/repo/driver_status_repository.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/logic/cubit/check_data_driver_screen_cubit.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/ui/widgets/car_widgets_information/car_information_card.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/ui/widgets/car_widgets_information/car_licenses_card.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/ui/widgets/driver_approval_actions.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/ui/widgets/driver_widgets_information/driver_id_card.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/ui/widgets/driver_widgets_information/driver_information_card.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/ui/widgets/driver_widgets_information/driver_licenses.dart';

class CheckDataDriverScreen extends StatelessWidget {
  final int driverId;
  final String userId;

  const CheckDataDriverScreen({
    super.key,
    required this.driverId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckDataDriverScreenCubit(
        DriverCarRepository(),
        DriverStatusRepository(),
      )..fetchDriverAndCar(driverId, userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text("تفاصيل السواق", style: TextStyles.font15Blackbold()),
          centerTitle: true,
          backgroundColor: ColorPalette.mainColor,
        ),
        body:
            BlocConsumer<
              CheckDataDriverScreenCubit,
              CheckDataDriverScreenState
            >(
              listener: (context, state) {
                if (state is DriverStatusUpdateLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is DriverStatusUpdateSuccess) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                }
                if (state is DriverStatusUpdateError) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title:  Text("خطأ",style: TextStyles.font15Blackbold()),
                      content: Text(state.message,style: TextStyles.font15Blackbold()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child:  Text("تمام",style: TextStyles.font15Blackbold()),
                        ),
                      ],
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CheckDataDriverScreenLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CheckDataDriverScreenError) {
                  return Center(
                    child: Text(
                      state.message ?? "حصل خطأ غير معروف",
                      style: TextStyles.font10redSemiBold(),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (state is CheckDataDriverScreenLoaded) {
                  final driver = state.driver;
                  final car = state.car;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DriverInformationCard(
                          imageUrl: driver.driverPhoto,
                          name: driver.driverFullname,
                          email: driver.email,
                          age: driver.age,
                        ),
                        Divider(thickness: 2.h),
                        verticalSpace(1),
                        DriverIdCard(
                          idFrontUrl: driver.driverIdCard,
                          idBackUrl: driver.idCardBack,
                          nationalId: driver.nationalId,
                        ),
                        Divider(thickness: 2.h),
                        verticalSpace(1),
                        DriverLicenses(
                          licenseFrontUrl: driver.driverLicenseFront,
                          licenseBackUrl: driver.driverLicenseBack,
                          licenseNumber: driver.licenseNumber,
                          licenseExpiryDate: driver.licenseExpiryDate
                              .toIso8601String(),
                        ),
                        Divider(thickness: 2.h),
                        verticalSpace(1),
                        CarLicensesCard(
                          licenseBackUrl: car.licenseFront,
                          licenseFrontUrl: car.licenseBack,
                        ),
                        Divider(thickness: 2.h),
                        verticalSpace(1),
                        CarInformationCard(
                          carBrand: car.carBrand,
                          carModel: car.carModel,
                          carColor: car.carColor,
                          plateNumber: car.plateNumber,
                          carPhoto: car.carPhoto,
                        ),
                        Divider(thickness: 2.h),
                        verticalSpace(2),
                        DriverApprovalActions(driverId: driverId),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
      ),
    );
  }
}
