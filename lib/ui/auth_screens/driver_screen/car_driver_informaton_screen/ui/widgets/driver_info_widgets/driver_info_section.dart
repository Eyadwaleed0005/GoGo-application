import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/logic/cubit/car_driver_information_cubit.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/widgets/driver_info_widgets/driver_info_form.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/widgets/driver_info_widgets/driver_info_images.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/widgets/submit_with_lottie_button.dart'; // الزرار الجديد

class DriverInfoSection extends StatelessWidget {
  const DriverInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarDriverInformationCubit>();
    final formKey = GlobalKey<FormState>();

    return BlocBuilder<CarDriverInformationCubit, CarDriverInformationState>(
      builder: (context, state) {
        List<String> missing = [];
        if (state is CarInfoUpdated) {
          missing = state.missingFields;
        }
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Driver Info', style: TextStyles.font20Blackbold()),
              verticalSpace(10),
              DriverImages(missingFields: missing),
              SizedBox(height: 20.h),
              DriverInfoForm(
                fullNameController: cubit.fullNameController,
                nationalIdController: cubit.nationalIdController,
                ageController: cubit.ageController,
                licenseNumberController: cubit.licenseNumberController,
                emailController: cubit.emailController,
                passwordController: cubit.passwordController,
                licenseExpiryController: cubit.licenseExpiryController,
              ),
              verticalSpace(20),
              SubmitButton(formKey: formKey), // هنا الزرار البسيط
            ],
          ),
        );
      },
    );
  }
}
