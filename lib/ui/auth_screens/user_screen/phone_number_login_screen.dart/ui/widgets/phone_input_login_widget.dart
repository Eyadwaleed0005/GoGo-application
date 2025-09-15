import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/widgets/custom_button.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_login_screen.dart/logic/phonenumberscreen_login_cubit.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_login_screen.dart/ui/widgets/password_field_login.dart';
import 'package:gogo/ui/auth_screens/user_screen/phone_number_login_screen.dart/ui/widgets/phone_field_with_country_picker_login.dart';

class PhoneInputLoginWidget extends StatefulWidget {
  final void Function(String phone, String password)? onValidSubmit;

  const PhoneInputLoginWidget({super.key, this.onValidSubmit});

  @override
  State<PhoneInputLoginWidget> createState() => _PhoneInputLoginWidgetState();
}

class _PhoneInputLoginWidgetState extends State<PhoneInputLoginWidget> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhonenumberscreenLoginCubit, PhonenumberscreenLoginState>(
      builder: (context, state) {
        if (state is! PhonenumberscreenLoginInitial) return const SizedBox();
        final selectedCountry = state.selectedCountry;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Form(
              key: formKey,
              child: Column(
                children: [
                  PhoneFieldWithCountryPickerLogin(
                    selectedCountry: selectedCountry,
                    onCountryChanged: (country) => context
                        .read<PhonenumberscreenLoginCubit>()
                        .changeCountry(country),
                    controller: phoneController,
                  ),
                  SizedBox(height: 16.h),
                  PasswordFieldLogin(controller: passwordController),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Center(
              child: CustomButton(
                text: 'Login',
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
