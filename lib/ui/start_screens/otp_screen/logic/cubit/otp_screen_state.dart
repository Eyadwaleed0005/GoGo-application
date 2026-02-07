part of 'otp_screen_cubit.dart';

@immutable
abstract class OtpScreenState {
  const OtpScreenState();
}

class OtpScreenInitial extends OtpScreenState {}

class OtpLoading extends OtpScreenState {}

class OtpSuccess extends OtpScreenState {}

class OtpFailure extends OtpScreenState {
  final String errorMessage;
  OtpFailure({required this.errorMessage});
}

class OtpTimerRunning extends OtpScreenState {
  final int secondsRemaining;
  OtpTimerRunning(this.secondsRemaining);
}

class OtpTimerFinished extends OtpScreenState {}
