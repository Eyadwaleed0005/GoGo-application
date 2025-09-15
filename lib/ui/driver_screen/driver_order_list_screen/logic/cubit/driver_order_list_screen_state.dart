part of 'driver_order_list_screen_cubit.dart';

@immutable
sealed class DriverOrderListScreenState {}

final class DriverOrderListScreenInitial extends DriverOrderListScreenState {}

final class DriverOrderListScreenLoading extends DriverOrderListScreenState {}

final class DriverOrderListScreenSuccess extends DriverOrderListScreenState {
  final UnmodifiableListView<GetAllOrdersModel> orders;
  DriverOrderListScreenSuccess(List<GetAllOrdersModel> orders)
      : orders = UnmodifiableListView(orders);
}

final class DriverOrderListScreenError extends DriverOrderListScreenState {
  final String message;
  DriverOrderListScreenError(this.message);
}

final class DriverOrderListScreenInactive extends DriverOrderListScreenState {}
