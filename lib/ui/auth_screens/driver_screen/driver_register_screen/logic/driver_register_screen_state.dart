abstract class DriverRegisterScreenState {
  const DriverRegisterScreenState();
}

class DriverRegisterInitial extends DriverRegisterScreenState {}

class DriverRegisterFormValid extends DriverRegisterScreenState {}

class DriverRegisterFormInvalid extends DriverRegisterScreenState {}

class DriverRegisterLoading extends DriverRegisterScreenState {}

class DriverRegisterSuccess extends DriverRegisterScreenState {}

class DriverRegisterFailure extends DriverRegisterScreenState {
  final String errorMessage;

  const DriverRegisterFailure({required this.errorMessage});
}
