part of 'driver_details_order_screen_cubit.dart';

@immutable
abstract class DriverDetailsOrderScreenState {}

class DriverDetailsOrderScreenInitial extends DriverDetailsOrderScreenState {}

class DriverDetailsOrderScreenLoading extends DriverDetailsOrderScreenState {}

class DriverDetailsOrderScreenSuccess extends DriverDetailsOrderScreenState {
  final GetAllOrdersModel order;
  DriverDetailsOrderScreenSuccess(this.order);
}

class DriverDetailsOrderScreenDeleted extends DriverDetailsOrderScreenState {}

class DriverDetailsOrderScreenError extends DriverDetailsOrderScreenState {
  final String message;
  DriverDetailsOrderScreenError(this.message);
}
