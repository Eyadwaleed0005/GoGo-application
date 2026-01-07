import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/app_system_ui.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/core/widgets/clickable_text_span.dart';
import 'package:gogo/core/widgets/orange_dot.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/system_ui_wrapper.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_login_screen/data/repo/login_repository.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_login_screen/logic/driver_login_screen_cubit.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_login_screen/logic/driver_login_screen_state.dart';
import 'widgets/driver_login_form_fields.dart';

class DriverLoginScreen extends StatelessWidget {
  const DriverLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverLoginScreenCubit(DriverLoginRepository()),
      child: BlocConsumer<DriverLoginScreenCubit, DriverLoginScreenState>(
        listener: (context, state) {
          if (state is DriverLoginLoading) {
            showBlockingAnimation(
              context: context,
              message: "loading".tr(),
              animationAsset: AppImage().loading,
              autoClose: false,
            );
          } else if (state is DriverLoginSuccess) {
            hideBlockingAnimation(context);
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                state.routeName,
                (route) => false,
              );
            }
          } else if (state is DriverLoginFailure) {
            hideBlockingAnimation(context);
            showBlockingAnimation(
              context: context,
              message: state.errorMessage,
              animationAsset: AppImage().error,
              autoClose: true,
              duration: const Duration(seconds: 2),
            );
          }
        },
        builder: (context, state) {
          return SystemUiWrapper(
            style: AppSystemUi.dark(),
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BackTextButton(onTap: () => Navigator.pop(context)),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'driver_sign_in'.tr(),
                                style: TextStyles.font21BlackBold(),
                              ),
                              horizontalSpace(6),
                              const OrangeDot(),
                            ],
                          ),
                        ),
                        verticalSpace(2),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'welcome_back_driver'.tr(),
                                style: TextStyles.font11GrayRegular(),
                              ),
                              Text(
                                'please_login_to_continue'.tr(),
                                style: TextStyles.font11GrayRegular(),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(35),
                        const DriverLoginFormFields(),
                        verticalSpace(18),
                        Center(
                          child: ClickableTextSpan(
                            normalText: 'dont_have_account'.tr(),
                            clickableText: 'sign_up_here'.tr(),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.driverRegisterScreen,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
