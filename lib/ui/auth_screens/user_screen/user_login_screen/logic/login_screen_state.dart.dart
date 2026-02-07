abstract class LoginScreenState {
  const LoginScreenState();
}

class LoginInitial extends LoginScreenState {}

class LoginLoading extends LoginScreenState {}

class LoginSuccess extends LoginScreenState {}

class LoginFailure extends LoginScreenState {
  final String errorMessage;
  const LoginFailure({required this.errorMessage});
}

class LoginFormValid extends LoginScreenState {}

class LoginFormInvalid extends LoginScreenState {}
