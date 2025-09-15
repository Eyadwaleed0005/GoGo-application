import 'package:flutter/material.dart';
import 'package:gogo/core/widgets/app_text_field.dart';

class PasswordFieldLogin extends StatelessWidget {
  final TextEditingController controller;

  const PasswordFieldLogin({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hint: 'Password',
      isPassword: true,
      controller: controller,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Enter password' : null,
    );
  }
}
