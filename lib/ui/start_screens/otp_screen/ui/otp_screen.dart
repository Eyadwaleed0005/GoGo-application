import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_login_screen.dart/ui/widgets/login_animation_widget.dart';
import 'package:gogo/ui/start_screens/otp_screen/logic/cubit/otp_screen_cubit.dart';
import 'package:gogo/ui/start_screens/otp_screen/repo/otp_repository.dart';
import 'package:gogo/ui/start_screens/otp_screen/ui/widgets/otp_header.dart';
import 'package:gogo/ui/start_screens/otp_screen/ui/widgets/otp_input_field.dart';
import 'package:gogo/ui/start_screens/otp_screen/ui/widgets/otp_resend_timer.dart';


class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();
    final phoneNumber = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (_) => OtpScreenCubit(OtpRepository())..startTimer(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackTextButton(onTap: () => Navigator.pop(context)),
                    LoginAnimationWidget(
                      animationPath: AppImage().otp,
                      height: 150.h,
                      width: 150.w,
                    ),
                    const OtpHeader(),
                    verticalSpace(20.h),
                    OtpInputField(controller: otpController),
                    verticalSpace(20.h),
                    OtpResendTimer(
                      onResend: () {
                        // Call resend API
                      },
                    ),
                  ],
                ),
                verticalSpace(15),
                BlocConsumer<OtpScreenCubit, OtpScreenState>(
                  listener: (context, state) {
                    if (state is OtpFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    } else if (state is OtpSuccess) {
                      // Navigate to next screen
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: state is OtpLoading ? 'Verifying...' : 'Verify',
                      onPressed: state is OtpLoading
                          ? null
                          : () {
                              context.read<OtpScreenCubit>().verifyOtp(
                                    phone: phoneNumber,
                                    otp: otpController.text.trim(),
                                  );
                            },
                      borderRadius: 8.r,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
