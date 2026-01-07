import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/clickable_text_span.dart';
import 'package:gogo/core/widgets/orange_dot.dart';
import 'package:gogo/core/widgets/animation_box.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/data/repo/login_repository.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/logic/login_screen_cubit.dart.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/logic/login_screen_state.dart.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/ui/widgets/login_form_fields.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginScreenCubit(LoginRepository()),
      child: BlocConsumer<LoginScreenCubit, LoginScreenState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            showBlockingAnimation(
              context: context,
              message: "loading".tr(),
              animationAsset: AppImage().loading,
              autoClose: false,
            );
          } else if (state is LoginSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homeScreen,
              (route) => false,
            );
          } else if (state is LoginFailure) {
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
                              'sign_in'.tr(),
                              style: TextStyles.font21BlackBold(),
                            ),
                            SizedBox(width: 6.w),
                            const OrangeDot(),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'login_description_line2'.tr(),
                              style: TextStyles.font11GrayRegular(),
                            ),
                            Text(
                              'login_description_line1'.tr(),
                              style: TextStyles.font11GrayRegular(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 35.h),
                      const LoginFormFields(),
                      SizedBox(height: 18.h),
                      Center(
                        child: ClickableTextSpan(
                          normalText: 'dont_have_account'.tr(),
                          clickableText: 'sign_up_here'.tr(),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.userRegisterScreen,
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
