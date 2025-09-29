import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/core/widgets/custom_refresh_widget.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/repo/driver_history_repository.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/logic/cubit/driver_history_screen_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/driver_history_list.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/title_history_widget.dart';

class DriverHistoryScreen extends StatelessWidget {
  const DriverHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DriverHistoryScreenCubit(DriverHistoryRepository())
            ..fetchDriverHistory(),
      child: Scaffold(
        body: SafeArea(
          child:
              BlocBuilder<DriverHistoryScreenCubit, DriverHistoryScreenState>(
                builder: (context, state) {
                  return CustomRefreshWidget(
                    onReload: () async {
                      context
                          .read<DriverHistoryScreenCubit>()
                          .fetchDriverHistory();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 6.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(10),
                          const Center(child: TitleHistoryWidget()),
                          verticalSpace(12),
                          _buildContent(context, state),
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

  Widget _buildContent(BuildContext context, DriverHistoryScreenState state) {
    if (state is DriverHistoryScreenLoading) {
      return Padding(
        padding: EdgeInsets.only(top: 180.h),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            color: ColorPalette.mainColor,
          ),
        ),
      );
    } else if (state is DriverHistoryScreenLoaded) {
      if (state.historyList.isEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: 70.h),
          child: AnimationBox(
            message: "no_trips_history".tr(),
            animationAsset: AppImage().emptyBox,
            textStyle: TextStyles.font12Blackbold(),
          ),
        );
      }
      return DriverHistoryList(historyData: state.historyList);
    } else if (state is DriverHistoryScreenError) {
      return Padding(
        padding: EdgeInsets.only(top: 70.h),
        child: AnimationBox(
          message: state.message,
          animationAsset: AppImage().error,
          textStyle: TextStyles.font10Blackbold(),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
