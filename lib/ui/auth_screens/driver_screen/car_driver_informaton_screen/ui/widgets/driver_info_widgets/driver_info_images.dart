import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/logic/cubit/car_driver_information_cubit.dart';
import 'package:gogo/core/widgets/image_picker_card.dart';

class DriverImages extends StatelessWidget {
  final List<String> missingFields;
  const DriverImages({super.key, required this.missingFields});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarDriverInformationCubit>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ImagePickerCard(
                label: 'driver_photo'.tr(),
                image: cubit.driverImage,
                onPick: cubit.pickDriverImage,
                isError: missingFields.contains('driver_photo'.tr()),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: ImagePickerCard(
                label: 'driver_with_id'.tr(),
                image: cubit.driverWithCardImage,
                onPick: cubit.pickDriverWithCardImage,
                isError: missingFields.contains('driver_with_id'.tr()),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: ImagePickerCard(
                label: 'driver_license_front'.tr(),
                image: cubit.driverLicenseFrontImage,
                onPick: cubit.pickDriverLicenseFrontImage,
                isError: missingFields.contains('driver_license_front'.tr()),
              ),
            ),
          ],
        ),
        verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: ImagePickerCard(
                label: 'driver_license_back'.tr(),
                image: cubit.driverLicenseBackImage,
                onPick: cubit.pickDriverLicenseBackImage,
                isError: missingFields.contains('driver_license_back'.tr()),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: ImagePickerCard(
                label: 'id_card_front'.tr(),
                image: cubit.idCardFrontImage,
                onPick: cubit.pickIdCardFrontImage,
                isError: missingFields.contains('id_card_front'.tr()),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: ImagePickerCard(
                label: 'id_card_back'.tr(),
                image: cubit.idCardBackImage,
                onPick: cubit.pickIdCardBackImage,
                isError: missingFields.contains('id_card_back'.tr()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
