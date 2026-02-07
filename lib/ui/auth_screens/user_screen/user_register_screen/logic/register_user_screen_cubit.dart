import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_register_screen/data/model/register_request_model.dart';
import 'package:gogo/ui/auth_screens/user_screen/user_register_screen/data/repo/auth_user_repository.dart';
import 'register_user_screen_state.dart';

class RegisterUserScreenCubit extends Cubit<RegisterUserScreenState> {
  final AuthUserRepository _authRepository;
  RegisterUserScreenCubit(this._authRepository) : super(RegisterUserInitial());

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String selectedUserType = "passenger";
  String selectedGender = "male";

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    emit(isValid ? RegisterUserFormValid() : RegisterUserFormInvalid());
    return isValid;
  }

  void changeGender(String gender) {
    selectedGender = gender;
    emit(RegisterUserGenderChanged(gender));
  }

  Future<void> registerUser() async {
    if (!validateForm()) return;

    emit(RegisterUserLoading());

    final model = RegisterRequestModel(
      email: emailController.text.trim(),
      fullName: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      password: passwordController.text,
      userType: selectedUserType,
      gender: selectedGender,
    );
    try {
      final response = await _authRepository.register(model);
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.token,
        value: response.token,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.userId,
        value: response.userId,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.displayName,
        value: response.dispalyName,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.email,
        value: response.email,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.phoneNumber,
        value: response.phoneNumber,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.userType,
        value: response.userType,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.gender,
        value: response.gender,
      );
      emit(RegisterUserSuccess());
    } catch (e) {
      emit(RegisterUserFailure(errorMessage: e.toString()));
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
