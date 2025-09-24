import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/logic/cubit/car_driver_information_cubit.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/data/repo/car_driver_information_repository.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/widgets/car_info_widgets/car_info_section.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/widgets/driver_info_widgets/driver_info_section.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/widgets/section_switcher.dart';
import 'package:easy_localization/easy_localization.dart';

class CarDriverInformationScreen extends StatelessWidget {
  const CarDriverInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => CarDriverInformationRepository(),
      child: BlocProvider(
        create: (context) => CarDriverInformationCubit(
          RepositoryProvider.of<CarDriverInformationRepository>(context),
        ),
        child: BlocListener<CarDriverInformationCubit, CarDriverInformationState>(
          listener: (context, state) {
            if (state is CarDriverUploadingImages) {
              hideBlockingAnimation(context);
              showBlockingAnimation(
                context: context,
                message: "uploading_images".tr(),
                animationAsset: AppImage().loading,
                autoClose: false,
              );
            } else if (state is CarDriverSubmittingDriverData) {
              hideBlockingAnimation(context);
              showBlockingAnimation(
                context: context,
                message: "submitting_driver_data".tr(),
                animationAsset: AppImage().loading,
                autoClose: false,
              );
            } else if (state is CarDriverSubmittingCarData) {
              hideBlockingAnimation(context);
              showBlockingAnimation(
                context: context,
                message: "submitting_car_data".tr(),
                animationAsset: AppImage().loading,
                autoClose: false,
              );
            } else if (state is CarDriverSubmissionSuccess) {
              hideBlockingAnimation(context);
              showBlockingAnimation(
                context: context,
                message: "",
                animationAsset: AppImage().sucsses,
                autoClose: true,
                duration: const Duration(seconds: 2),
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.onWaitingDriver,
                    (route) => false,
                  );
                }
              });
            } else if (state is CarDriverSubmissionFailure) {
              hideBlockingAnimation(context);
              showBlockingAnimation(
                context: context,
                message: state.error,
                animationAsset: AppImage().error,
                autoClose: true,
                duration: const Duration(seconds: 2),
              );
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackTextButton(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.driverAuthScreen,
                          (route) => false,
                        );
                      },
                    ),
                    verticalSpace(20),
                    Expanded(
                      child: SectionSwitcher(
                        sections: const [
                          CarInfoSection(),
                          DriverInfoSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
