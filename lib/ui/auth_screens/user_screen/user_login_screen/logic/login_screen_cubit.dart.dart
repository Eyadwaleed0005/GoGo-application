import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/data/model/login_request_model.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/data/repo/login_repository.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_login_screen/logic/login_screen_state.dart.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  final LoginRepository _loginRepository;

  LoginScreenCubit(this._loginRepository) : super(LoginInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool validateForm() {
    final isValidForm = formKey.currentState?.validate() ?? false;
    emit(isValidForm ? LoginFormValid() : LoginFormInvalid());
    return isValidForm;
  }

Future<void> loginUser() async {
  if (!validateForm()) return;

  emit(LoginLoading());

  final model = LoginRequestModel(
    emailOrPhone: emailController.text.trim(),
    password: passwordController.text,
  );

  try {
    final response = await _loginRepository.login(model);

    if (response.userType.toLowerCase() != "passenger") {
      emit(LoginFailure(errorMessage: 'account_not_user'.tr()),);
      return;
    }
    await SecureStorageHelper.savedata(
        key: SecureStorageKeys.token, value: response.token);
    await SecureStorageHelper.savedata(
        key: SecureStorageKeys.userId, value: response.userId);
    await SecureStorageHelper.savedata(
        key: SecureStorageKeys.email, value: response.email);
    await SecureStorageHelper.savedata(
        key: SecureStorageKeys.displayName, value: response.displayName);
    await SecureStorageHelper.savedata(
        key: SecureStorageKeys.phoneNumber, value: response.phoneNumber);
    await SecureStorageHelper.savedata(
        key: SecureStorageKeys.userType, value: response.userType);
    await SecureStorageHelper.savedata(
        key: SecureStorageKeys.gender, value: response.gender);


    emit(LoginSuccess());
  } catch (e) {
    emit(LoginFailure(errorMessage: e.toString()));
  }
}


}
