import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/logic/cubit/driver_profile_screen_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/ui/widgets/driver_information_widget/driver_information_widget.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/ui/widgets/driver_profile_header_widget/driver_profile_header_widget.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/ui/widgets/log_out_buttom.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/ui/widgets/rating_widget.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/ui/widgets/total_money_widgets/total_money_today.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/repo/repo_driver_profile_screen.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/widgets/custom_refresh_widget.dart';


class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = DriverProfileScreenCubit(DriverRepository());
        cubit.fetchDriverProfile();
        return cubit;
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<DriverProfileScreenCubit, DriverProfileScreenState>(
            builder: (context, state) {
              return CustomRefreshWidget(
                onReload: () async {
                  context.read<DriverProfileScreenCubit>().fetchDriverProfile();
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 25.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DriverProfileHeader(),
                      verticalSpace(20),
                      Row(
                        children: [
                          horizontalSpace(25),
                          const RatingWidget(),
                        ],
                      ),
                      verticalSpace(10),
                      const TotalMoneyToday(),
                      verticalSpace(2),
                      const DriverInformationWidget(),
                      verticalSpace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LogOutButton(),
                          horizontalSpace(15),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
