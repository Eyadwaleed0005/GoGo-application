part of 'car_driver_information_cubit.dart';

@immutable
sealed class CarDriverInformationState {}

final class CarDriverInformationInitial extends CarDriverInformationState {}

final class CarInfoUpdated extends CarDriverInformationState {
  final List<String> missingFields;
  CarInfoUpdated(this.missingFields);
}

final class CarDriverUploadingImages extends CarDriverInformationState {}

final class CarDriverSubmittingDriverData extends CarDriverInformationState {}

final class CarDriverSubmittingCarData extends CarDriverInformationState {}

final class CarDriverSubmissionSuccess extends CarDriverInformationState {}

final class CarDriverSubmissionFailure extends CarDriverInformationState {
  final String error;
  CarDriverSubmissionFailure(this.error);
}
