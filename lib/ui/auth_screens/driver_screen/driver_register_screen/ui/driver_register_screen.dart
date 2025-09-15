import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/clickable_text_span.dart';
import 'package:gogo/core/widgets/orange_dot.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/data/repo/driver_auth_repository.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/logic/driver_register_screen_cubit.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/logic/driver_register_screen_state.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/ui/widgets/register_form_fields.dart';

class DriverRegisterScreen extends StatelessWidget {
  const DriverRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverRegisterScreenCubit(DriverAuthRepository()),
      child: BlocConsumer<DriverRegisterScreenCubit, DriverRegisterScreenState>(
        listener: (context, state) {
          if (state is DriverRegisterLoading) {
            showBlockingAnimation(
              context: context,
              message: "Loading",
              animationAsset: AppImage().loading,
              autoClose: false,
            );
          } else if (state is DriverRegisterSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.carDriverInformationScreen,
              (route) => false,
            );
          } else if (state is DriverRegisterFailure) {
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
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackTextButton(onTap: () => Navigator.pop(context)),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Driver Sign Up',
                              style: TextStyles.font21BlackBold(),
                            ),
                            SizedBox(width: 6.w),
                            Transform.translate(
                              offset: Offset(0, 12.h),
                              child: const OrangeDot(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Please fill in driver registration info',
                              style: TextStyles.font11GrayRegular(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      const RegisterFormFields(),
                      SizedBox(height: 18.h),
                      Center(
                        child: ClickableTextSpan(
                          normalText: 'Already have an account? ',
                          clickableText: 'Sign in Here',
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.loginScreen,
                            );
                          },
                        ),
                      ),
                    ],
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
