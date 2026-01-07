part of 'send_arrival_notification_button_cubit.dart';

@immutable
abstract class SendArrivalNotificationButtonState {}

class SendArrivalNotificationButtonInitial
    extends SendArrivalNotificationButtonState {}

class SendArrivalNotificationButtonLoading
    extends SendArrivalNotificationButtonState {}

class SendArrivalNotificationButtonSuccess
    extends SendArrivalNotificationButtonState {}

class SendArrivalNotificationButtonFailure
    extends SendArrivalNotificationButtonState {
  final String message;
  SendArrivalNotificationButtonFailure(this.message);
}
