import 'package:flutter/material.dart';
import 'package:gogo/core/widgets/app_text_field.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

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
