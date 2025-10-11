import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/logic/cubit/car_driver_information_cubit.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/widgets/car_info_widgets/car_info_form.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/ui/widgets/car_info_widgets/car_info_images.dart';

class CarInfoSection extends StatelessWidget {
  const CarInfoSection({super.key});

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
              Text(
                'car_info'.tr(), 
                style: TextStyles.font20Blackbold(),
              ),
              verticalSpace(10),
              CarInfoImages(missingFields: missing),
              SizedBox(height: 20.h),
              CarInfoForm(
                brandController: cubit.brandController,
                modelController: cubit.modelController,
                colorController: cubit.colorController,
                plateController: cubit.plateController,
              ),
            ],
          ),
        );
      },
    );
  }
}
