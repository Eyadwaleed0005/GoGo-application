part of 'phonenumberscreen_cubit.dart';

@immutable
abstract class PhonenumberscreenState {}

class PhonenumberscreenInitial extends PhonenumberscreenState {
  final Country selectedCountry;
  PhonenumberscreenInitial({required this.selectedCountry});
}
