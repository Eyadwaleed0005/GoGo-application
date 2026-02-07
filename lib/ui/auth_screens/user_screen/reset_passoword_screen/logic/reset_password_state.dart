abstract class ResetPasswordState {
  final bool isValid;

  ResetPasswordState({this.isValid = false});
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordFormValid extends ResetPasswordState {
  ResetPasswordFormValid() : super(isValid: true);
}

class ResetPasswordFormInvalid extends ResetPasswordState {
  ResetPasswordFormInvalid() : super(isValid: false);
}
