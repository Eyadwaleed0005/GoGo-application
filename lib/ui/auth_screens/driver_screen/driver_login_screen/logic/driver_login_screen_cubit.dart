import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_login_screen/data/model/driver_login_request_model.dart';
import 'package:gogo/ui/auth_screens/driver_screen/driver_login_screen/data/repo/login_repository.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/model/driver-status-model.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/repo/driver_status_repository.dart';
import 'driver_login_screen_state.dart';

class DriverLoginScreenCubit extends Cubit<DriverLoginScreenState> {
  final DriverLoginRepository _loginRepository;
  final DriverStatusRepository _driverStatusRepository =
      DriverStatusRepository();

  DriverLoginScreenCubit(this._loginRepository) : super(DriverLoginInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool validateForm() {
    final isValidForm = formKey.currentState?.validate() ?? false;
    emit(isValidForm ? DriverLoginFormValid() : DriverLoginFormInvalid());
    return isValidForm;
  }

  Future<void> loginUser() async {
    if (!validateForm()) return;

    emit(DriverLoginLoading());

    final model = DriverLoginRequestModel(
      emailOrPhone: emailController.text.trim(),
      password: passwordController.text,
    );

    try {
      final response = await _loginRepository.login(model);

      if (response.userType.toLowerCase() != "driver") {
        emit(DriverLoginFailure(errorMessage: " This Account isn't  A Driver"));
        return;
      }

      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.token,
        value: response.token,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.userId,
        value: response.userId,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.email,
        value: response.email,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.displayName,
        value: response.displayName,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.phoneNumber,
        value: response.phoneNumber,
      );
      await SecureStorageHelper.savedata(
        key: SecureStorageKeys.userType,
        value: response.userType,
      );

      String routeName = AppRoutes.accountTypeScreen;

      final DriverStatusModel status = await _driverStatusRepository
          .getDriverStatus();

      await SharedPreferencesHelper.saveString(
        key: SharedPreferenceKeys.statusOfAccountDriver,
        value: status.status,
      );
      await SharedPreferencesHelper.saveBool(
        key: SharedPreferenceKeys.driverCompleteRegister,
        value: true,
      );

      if (status.status == "approved") {
        routeName = AppRoutes.driverHomeScreen;
      } else if (status.status == "pending") {
        routeName = AppRoutes.onWaitingDriver;
      } else if (status.status == "reject") {
        routeName = AppRoutes.rejectDriverScreen;
      }
      emit(DriverLoginSuccess(routeName: routeName));
    } catch (e) {
      emit(DriverLoginFailure(errorMessage: e.toString()));
    }
  }
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
