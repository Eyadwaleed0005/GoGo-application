import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gogo/ui/start_screens/otp_screen/model/otp_verify_model.dart';
import 'package:gogo/ui/start_screens/otp_screen/repo/otp_repository.dart';
part 'otp_screen_state.dart';

class OtpScreenCubit extends Cubit<OtpScreenState> {
  final OtpRepository _otpRepository;
  OtpScreenCubit(this._otpRepository) : super(OtpScreenInitial());

  static const int _initialTime = 45;
  Timer? _timer;
  int _secondsRemaining = _initialTime;

  void startTimer() {
    _secondsRemaining = _initialTime;
    emit(OtpTimerRunning(_secondsRemaining));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;

      if (_secondsRemaining <= 0) {
        _timer?.cancel();
        emit(OtpTimerFinished());
      } else {
        emit(OtpTimerRunning(_secondsRemaining));
      }
    });
  }

  void resendCode(VoidCallback onResend) {
    onResend();
    startTimer();
  }

  Future<void> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    emit(OtpLoading());

    final model = OtpVerifyModel(phoneNumber: phone, otp: otp);

    try {
      await _otpRepository.verifyOtp(model);
      emit(OtpSuccess());
    } catch (e) {
      emit(OtpFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
