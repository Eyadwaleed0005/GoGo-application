import 'package:bloc/bloc.dart';
import 'package:country_picker/country_picker.dart';
import 'package:meta/meta.dart';

part 'phonenumberscreen_state.dart';

class PhonenumberscreenCubit extends Cubit<PhonenumberscreenState> {
  PhonenumberscreenCubit()
      : super(PhonenumberscreenInitial(
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
    emit(PhonenumberscreenInitial(selectedCountry: newCountry));
  }
}
