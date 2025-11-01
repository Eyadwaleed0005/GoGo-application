abstract class RegisterUserScreenState {
  const RegisterUserScreenState();
}

class RegisterUserInitial extends RegisterUserScreenState {}

class RegisterUserFormValid extends RegisterUserScreenState {}

class RegisterUserFormInvalid extends RegisterUserScreenState {}

class RegisterUserLoading extends RegisterUserScreenState {}

class RegisterUserSuccess extends RegisterUserScreenState {}

class RegisterUserFailure extends RegisterUserScreenState {
  final String errorMessage;

  const RegisterUserFailure({required this.errorMessage});
}

class RegisterUserGenderChanged extends RegisterUserScreenState {
  final String gender;
  const RegisterUserGenderChanged(this.gender);
}
