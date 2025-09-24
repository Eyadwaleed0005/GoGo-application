import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/logic/cubit/car_driver_information_cubit.dart';
import 'package:gogo/core/widgets/image_picker_card.dart';
import 'package:easy_localization/easy_localization.dart';

class CarInfoImages extends StatelessWidget {
  final List<String> missingFields;
  const CarInfoImages({super.key, required this.missingFields});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarDriverInformationCubit>();

    return Row(
      children: [
        Expanded(
          child: ImagePickerCard(
            label: "car_photo".tr(),
            image: cubit.carImage,
            onPick: cubit.pickCarImage,
            isError: missingFields.contains("Car Photo"),
          ),
        ),
        verticalSpace(12),
        Expanded(
          child: ImagePickerCard(
            label: "license_front".tr(),
            image: cubit.licenseFrontImage,
            onPick: cubit.pickLicenseFrontImage,
            isError: missingFields.contains("License (Front)"),
          ),
        ),
        verticalSpace(12),
        Expanded(
          child: ImagePickerCard(
            label: "license_back".tr(),
            image: cubit.licenseBackImage,
            onPick: cubit.pickLicenseBackImage,
            isError: missingFields.contains("License (Back)"),
          ),
        ),
      ],
    );
  }
}
