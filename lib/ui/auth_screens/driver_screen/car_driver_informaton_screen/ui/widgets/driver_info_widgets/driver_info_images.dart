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
                label: "Driver Photo",
                image: cubit.driverImage,
                onPick: cubit.pickDriverImage,
                isError: missingFields.contains("Driver Photo"),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: ImagePickerCard(
                label: "Driver with ID Card",
                image: cubit.driverWithCardImage,
                onPick: cubit.pickDriverWithCardImage,
                isError: missingFields.contains("Driver with ID Card"),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: ImagePickerCard(
                label: "Driver License (Front)",
                image: cubit.driverLicenseFrontImage,
                onPick: cubit.pickDriverLicenseFrontImage,
                isError: missingFields.contains("Driver License (Front)"),
              ),
            ),
          ],
        ),
        verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: ImagePickerCard(
                label: "Driver License (Back)",
                image: cubit.driverLicenseBackImage,
                onPick: cubit.pickDriverLicenseBackImage,
                isError: missingFields.contains("Driver License (Back)"),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: ImagePickerCard(
                label: "ID Card (Front)",
                image: cubit.idCardFrontImage,
                onPick: cubit.pickIdCardFrontImage,
                isError: missingFields.contains("ID Card (Front)"),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: ImagePickerCard(
                label: "ID Card (Back)",
                image: cubit.idCardBackImage,
                onPick: cubit.pickIdCardBackImage,
                isError: missingFields.contains("ID Card (Back)"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
