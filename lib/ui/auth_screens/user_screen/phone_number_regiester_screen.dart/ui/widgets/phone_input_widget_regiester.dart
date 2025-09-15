import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_regiester_screen.dart/logic/cubit/phonenumberscreen_cubit.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_regiester_screen.dart/ui/widgets/phone_field_with_country_picker_register.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_regiester_screen.dart/ui/widgets/password_field_register.dart';

class PhoneInputWidget extends StatefulWidget {
  final void Function(String phone, String password)? onValidSubmit;

  const PhoneInputWidget({super.key, this.onValidSubmit});

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhonenumberscreenCubit, PhonenumberscreenState>(
      builder: (context, state) {
        if (state is! PhonenumberscreenInitial) return const SizedBox();
        final selectedCountry = state.selectedCountry;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Form(
              key: formKey,
              child: Column(
                children: [
                  PhoneFieldWithCountryPicker(
                    selectedCountry: selectedCountry,
                    onCountryChanged: (country) => context
                        .read<PhonenumberscreenCubit>()
                        .changeCountry(country),
                    controller: phoneController,
                  ),
                  SizedBox(height: 16.h),
                  PasswordField(controller: passwordController),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Center(
              child: CustomButton(
                text: 'Continue',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final fullPhone =
                        '+${selectedCountry.phoneCode}${phoneController.text}';
                    widget.onValidSubmit?.call(fullPhone, passwordController.text);
                  }
                },
                borderRadius: 8.r,
              ),
            ),
          ],
        );
      },
    );
  }
}
