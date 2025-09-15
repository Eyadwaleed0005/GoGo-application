import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/start_screens/on_boarding_screens/logic/on_boarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState(currentPage: 0));

  void nextPage(int index) {
    emit(OnboardingState(currentPage: index));
  }
}
