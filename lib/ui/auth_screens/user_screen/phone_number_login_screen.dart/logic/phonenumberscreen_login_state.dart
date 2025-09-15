part of 'phonenumberscreen_login_cubit.dart';

@immutable
abstract class PhonenumberscreenLoginState {}

class PhonenumberscreenLoginInitial extends PhonenumberscreenLoginState {
  final Country selectedCountry;
  PhonenumberscreenLoginInitial({required this.selectedCountry});
}

class PhonenumberscreenLoginLoading extends PhonenumberscreenLoginState {}

class PhonenumberscreenLoginSuccess extends PhonenumberscreenLoginState {}

class PhonenumberscreenLoginFailure extends PhonenumberscreenLoginState {
  final String error;
  PhonenumberscreenLoginFailure({required this.error});
}
