import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/send_message_repo.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/logic/send_arrival_notification_button_cubit.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ للترجمة

class SendArrivalNotificationButton extends StatelessWidget {
  final String projectId;
  const SendArrivalNotificationButton({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SendArrivalNotificationButtonCubit(
        repo: SendMessageRepo(projectId: projectId),
      ),
      child: Builder(
        builder: (context) {
          final messenger = ScaffoldMessenger.of(context); // cache instance
          return BlocConsumer<SendArrivalNotificationButtonCubit,
              SendArrivalNotificationButtonState>(
            listener: (context, state) {
              if (!context.mounted) return;

              messenger.hideCurrentMaterialBanner();

              if (state is SendArrivalNotificationButtonFailure) {
                messenger.showMaterialBanner(
                  MaterialBanner(
                    content: Text(
                      state.message,
                      style: TextStyles.font10whitebold(),
                    ),
                    backgroundColor: Colors.red,
                    actions: [
                      TextButton(
                        onPressed: messenger.hideCurrentMaterialBanner,
                        child: Text(
                          "dismiss".tr(), // ✅ قابل للترجمة
                          style: TextStyles.font10whitebold(),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is SendArrivalNotificationButtonSuccess) {
                messenger.showMaterialBanner(
                  MaterialBanner(
                    content: Text(
                      "notification_sent".tr(), // ✅ قابل للترجمة
                      style: TextStyles.font10whitebold(),
                    ),
                    backgroundColor: Colors.green,
                    actions: [
                      TextButton(
                        onPressed: messenger.hideCurrentMaterialBanner,
                        child: Text(
                          "dismiss".tr(), // ✅ قابل للترجمة
                          style: TextStyles.font10whitebold(),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is SendArrivalNotificationButtonLoading;
              return Column(
                children: [
                  InkWell(
                    onTap: isLoading
                        ? null
                        : () {
                            final cubit =
                                context.read<SendArrivalNotificationButtonCubit>();
                            cubit.sendArrivalNotification();
                          },
                    borderRadius: BorderRadius.circular(50.r),
                    child: CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      radius: 24.r,
                      child: isLoading
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: Colors.orange,
                              ),
                            )
                          : Icon(Icons.directions_car,
                              color: Colors.orange, size: 22.sp),
                    ),
                  ),
                  verticalSpace(8),
                  Text(
                    "arrived".tr(), // ✅ قابل للترجمة
                    style: const TextStyle(color: ColorPalette.textDark),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
