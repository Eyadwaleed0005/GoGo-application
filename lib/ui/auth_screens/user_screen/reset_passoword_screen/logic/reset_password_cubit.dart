import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool validateForm() {
    bool isValidForm = formKey.currentState?.validate() ?? false;
    if (isValidForm) {
      emit(ResetPasswordFormValid());
    } else {
      emit(ResetPasswordFormInvalid());
    }
    return isValidForm;
  }

  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
