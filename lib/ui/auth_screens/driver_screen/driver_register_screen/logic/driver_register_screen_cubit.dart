import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/models/user_driver_response_model.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/data/model/register_request_model.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/data/repo/driver_auth_repository.dart';
import 'driver_register_screen_state.dart';

class DriverRegisterScreenCubit extends Cubit<DriverRegisterScreenState> {
  final DriverAuthRepository _authRepository;

  DriverRegisterScreenCubit(this._authRepository)
      : super(DriverRegisterInitial());

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String selectedUserType = "driver";
  String selectedGender = "male"; // small letters ✅

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    emit(isValid ? DriverRegisterFormValid() : DriverRegisterFormInvalid());
    return isValid;
  }

  void changeGender(String gender) {
    selectedGender = gender;
    emit(DriverRegisterGenderChanged(gender)); // 🔥 الحالة الجديدة
  }

  Future<void> registerDriver() async {
    if (!validateForm()) return;

    emit(DriverRegisterLoading());

    final model = RegisterRequestModel(
      email: emailController.text.trim(),
      fullName: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      password: passwordController.text,
      userType: selectedUserType,
      gender: selectedGender, // small ✅
    );

    try {
      final UserDriverResponseModel response =
          await _authRepository.register(model);

      await SecureStorageHelper.savedata(
          key: SecureStorageKeys.userId, value: response.userId);
      await SecureStorageHelper.savedata(
          key: SecureStorageKeys.email, value: response.email);
      await SecureStorageHelper.savedata(
          key: SecureStorageKeys.password, value: passwordController.text);
      await SecureStorageHelper.savedata(
          key: SecureStorageKeys.displayName, value: response.dispalyName);
      await SecureStorageHelper.savedata(
          key: SecureStorageKeys.phoneNumber, value: response.phoneNumber);
      await SecureStorageHelper.savedata(
          key: SecureStorageKeys.userType, value: response.userType);
      await SecureStorageHelper.savedata(
          key: SecureStorageKeys.gender, value: response.gender);
      if (response.token.isNotEmpty) {
        await SecureStorageHelper.savedata(
            key: SecureStorageKeys.token, value: response.token);
      }

      emit(DriverRegisterSuccess());
    } catch (e) {
      emit(DriverRegisterFailure(errorMessage: e.toString()));
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
