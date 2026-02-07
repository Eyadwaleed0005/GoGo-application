part of 'driver_amount_cubit.dart';

@immutable
sealed class DriverAmountState {}

final class DriverAmountInitial extends DriverAmountState {}

final class DriverAmountLoading extends DriverAmountState {}

final class DriverAmountSuccess extends DriverAmountState {
  final int deductedAmount; // القيمة اللي تم خصمها
  DriverAmountSuccess(this.deductedAmount);
}

final class DriverAmountError extends DriverAmountState {
  final String message;
  DriverAmountError(this.message);
}
