part of 'send_arrival_notification_button_cubit.dart';

@immutable
sealed class SendArrivalNotificationButtonState {}

final class SendArrivalNotificationButtonInitial extends SendArrivalNotificationButtonState {}

final class SendArrivalNotificationButtonLoading extends SendArrivalNotificationButtonState {}

final class SendArrivalNotificationButtonSuccess extends SendArrivalNotificationButtonState {}

final class SendArrivalNotificationButtonFailure extends SendArrivalNotificationButtonState {
  final String message;
  SendArrivalNotificationButtonFailure(this.message);
}
