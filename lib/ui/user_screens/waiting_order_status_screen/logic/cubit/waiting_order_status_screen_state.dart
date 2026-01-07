part of 'waiting_order_status_screen_cubit.dart';

@immutable
sealed class WaitingOrderStatusScreenState {}

final class WaitingOrderStatusScreenInitial extends WaitingOrderStatusScreenState {}

final class WaitingOrderStatusLoading extends WaitingOrderStatusScreenState {}

final class WaitingOrderStatusLoaded extends WaitingOrderStatusScreenState {
  final GetAllOrdersModel order;
  WaitingOrderStatusLoaded(this.order);
}

final class WaitingOrderApproved extends WaitingOrderStatusScreenState {
  final GetAllOrdersModel order;
  WaitingOrderApproved(this.order);
}

final class WaitingOrderCancelled extends WaitingOrderStatusScreenState {
  final GetAllOrdersModel order;
  WaitingOrderCancelled(this.order);
}

final class WaitingOrderCancelledManually extends WaitingOrderStatusScreenState {}

final class WaitingOrderNoDriverFound extends WaitingOrderStatusScreenState {}

final class WaitingOrderStatusError extends WaitingOrderStatusScreenState {
  final String message;
  WaitingOrderStatusError(this.message);
}
