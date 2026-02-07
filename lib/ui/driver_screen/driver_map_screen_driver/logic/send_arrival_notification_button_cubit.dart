import 'package:bloc/bloc.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/send_message_repo.dart';
import 'package:meta/meta.dart';

part 'send_arrival_notification_button_state.dart';

class SendArrivalNotificationButtonCubit
    extends Cubit<SendArrivalNotificationButtonState> {
  final SendMessageRepo repo;

  SendArrivalNotificationButtonCubit({required this.repo})
      : super(SendArrivalNotificationButtonInitial());

 Future<void> sendArrivalNotification() async {
  if (isClosed) return; 
  emit(SendArrivalNotificationButtonLoading());

  try {
    final orderId = await repo.getOrderId();
    if (orderId == null) {
      if (!isClosed) emit(SendArrivalNotificationButtonFailure("Order ID not found"));
      return;
    }

    final fcmToken = await repo.getFcmToken(orderId);
    if (fcmToken == null) {
      if (!isClosed) emit(SendArrivalNotificationButtonFailure("FCM token not found"));
      return;
    }

    await repo.sendNotification(token: fcmToken);
    if (!isClosed) emit(SendArrivalNotificationButtonSuccess());
  } catch (e) {
    if (!isClosed) emit(SendArrivalNotificationButtonFailure("Error sending notification: $e"));
  }
}

}
