abstract class DriverLoginScreenState {
  const DriverLoginScreenState();
}

class DriverLoginInitial extends DriverLoginScreenState {}

class DriverLoginLoading extends DriverLoginScreenState {}

class DriverLoginSuccess extends DriverLoginScreenState {
  final String routeName;
  const DriverLoginSuccess({required this.routeName});
}

class DriverLoginFailure extends DriverLoginScreenState {
  final String errorMessage;
  const DriverLoginFailure({required this.errorMessage});
}

class DriverLoginFormValid extends DriverLoginScreenState {}

class DriverLoginFormInvalid extends DriverLoginScreenState {}
