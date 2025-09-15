import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/logic/cubit/car_driver_information_cubit.dart';

class SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SubmitButton({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CarDriverInformationCubit>();

    return CustomButton(
      borderRadius: 8.r,
      text: "Submit",
      onPressed: () {
        final missingFields = cubit.validateCarInfo();
        if (formKey.currentState!.validate() && missingFields.isEmpty) {
          cubit.submitData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ يرجى إدخال جميع الحقول المطلوبة")),
          );
        }
      },
    );
  }
}
