import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/background_widget.dart';
import 'package:gogo/ui/user_screens/user_history_screen.dart/ui/widgets/user_history_list.dart';
import 'package:lottie/lottie.dart';
import '../data/repo/user_history_repository.dart';
import '../logic/cubit/user_history_screen_cubit.dart';
import 'widgets/user_history_appbar.dart';

class UserHistoryScreen extends StatelessWidget {
  final String? profileImageUrl;

  const UserHistoryScreen({super.key, required this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserHistoryScreenCubit(UserHistoryRepository())..fetchUserHistory(),
      child: Scaffold(
        appBar: UserHistoryAppBar(profileImageUrl: profileImageUrl),
        body: BackgroundWidget(
          imagePath: AppImage().backGround2,
          isAsset: true,
          child: BlocBuilder<UserHistoryScreenCubit, UserHistoryScreenState>(
            builder: (context, state) {
              if (state is UserHistoryScreenLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(AppImage().loading, width: 200.w, height: 200.h),
                      verticalSpace(6),
                      Text("Loading...", style: TextStyles.font12whitebold()),
                    ],
                  ),
                );
              } else if (state is UserHistoryScreenSuccess) {
                return UserHistoryList(history: state.history);
              } else if (state is UserHistoryScreenEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        AppImage().emptyBox,
                        width: 200.w,
                        height: 200.h,
                      ),
                      verticalSpace(6),
                      Text(
                        "No history found yet!",
                        style: TextStyles.font12whitebold(),
                      ),
                    ],
                  ),
                );
              } else if (state is UserHistoryScreenFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        AppImage().error,
                        width: 200.w,
                        height: 200.h,
                      ),
                      verticalSpace(3),
                      Text(
                        state.error,
                        style: TextStyles.font12whitebold(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
