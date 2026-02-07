part of 'splash_screen_cubit.dart';

@immutable
abstract class SplashScreenState {}

class SplashScreenInitial extends SplashScreenState {}

class SplashScreenLoading extends SplashScreenState {}

class SplashScreenDriverApproved extends SplashScreenState {}

class SplashScreenDriverPending extends SplashScreenState {}
class SplashScreenDriverRejected extends SplashScreenState {}

class SplashScreenDriverStartTrip extends SplashScreenState {}

class SplashScreenDriverEndTrip extends SplashScreenState {}

class SplashScreenPassenger extends SplashScreenState {}

class SplashScreenUnAuthenticated extends SplashScreenState {}

class SplashScreenUnAuthenticatedToLanguage extends SplashScreenState {}

class SplashScreenFailure extends SplashScreenState {
  final String errorMessage;
  SplashScreenFailure({required this.errorMessage});
}
