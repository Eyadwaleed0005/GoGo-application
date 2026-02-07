import 'package:bloc/bloc.dart';
import 'package:country_picker/country_picker.dart';
import 'package:meta/meta.dart';

part 'phonenumberscreen_login_state.dart';

class PhonenumberscreenLoginCubit extends Cubit<PhonenumberscreenLoginState> {
  PhonenumberscreenLoginCubit()
      : super(PhonenumberscreenLoginInitial(
          selectedCountry: Country(
            phoneCode: '20',
            countryCode: 'EG',
            e164Sc: 0,
            geographic: true,
            level: 1,
            name: 'Egypt',
            example: '0123456789',
            displayName: 'Egypt',
            displayNameNoCountryCode: 'Egypt',
            e164Key: '',
          ),
        ));

  void changeCountry(Country newCountry) {
    emit(PhonenumberscreenLoginInitial(selectedCountry: newCountry));
  }

  Future<void> login(String phone, String password) async {
    emit(PhonenumberscreenLoginLoading());
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate request
      emit(PhonenumberscreenLoginSuccess());
    } catch (e) {
      emit(PhonenumberscreenLoginFailure(error: e.toString()));
    }
  }
}
