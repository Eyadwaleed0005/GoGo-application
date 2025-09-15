import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/start_screens/otp_screen/logic/cubit/otp_screen_cubit.dart';

class OtpResendTimer extends StatelessWidget {
  final VoidCallback onResend;

  const OtpResendTimer({super.key, required this.onResend});

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpScreenCubit, OtpScreenState>(
      builder: (context, state) {
        if (state is OtpTimerRunning) {
          return Center(
            child: Column(
              children: [
                Text(
                  _formatTime(state.secondsRemaining),
                  style: TextStyles.font10BlackSemiBold(),
                ),
                verticalSpace(16.h),
                Text(
                  "Didn't receive the code? Resend",
                  style: TextStyles.font10BlackSemiBold().copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              children: [
                Text(
                  '00:00',
                  style: TextStyles.font10BlackSemiBold(),
                ),
                verticalSpace(12.h),
                GestureDetector(
                  onTap: () {
                    context.read<OtpScreenCubit>().resendCode(onResend);
                  },
                  child: Text(
                    "Didn't receive the code? Resend",
                    style: TextStyles.font10BlackSemiBold().copyWith(
                      color: ColorPalette.mainColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
