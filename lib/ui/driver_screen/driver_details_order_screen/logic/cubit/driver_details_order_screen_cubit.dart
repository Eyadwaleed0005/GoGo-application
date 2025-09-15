import 'package:bloc/bloc.dart';
import 'package:gogo/core/const/const_things_of_admin.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/widgets/confirmation_dialog.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/data/repo/order_details_repository.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/repo/driver_wallet_repository.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'driver_details_order_screen_state.dart';

class DriverDetailsOrderScreenCubit
    extends Cubit<DriverDetailsOrderScreenState> {
  final OrderDetailsRepository repository;
  final DriverWalletRepository walletRepository;

  DriverDetailsOrderScreenCubit({
    required this.repository,
    required this.walletRepository,
  }) : super(DriverDetailsOrderScreenInitial());

  Future<void> fetchOrderDetails(int orderId) async {
    if (isClosed) return;
    emit(DriverDetailsOrderScreenLoading());

    try {
      final order = await repository.getOrderDetails(orderId);

      if (isClosed) return;
      if (order != null) {
        emit(DriverDetailsOrderScreenSuccess(order));
      } else {
        emit(DriverDetailsOrderScreenError("Order not found"));
      }
    } catch (e) {
      if (!isClosed) emit(DriverDetailsOrderScreenError(e.toString()));
    }
  }

  Future<void> acceptOrder(BuildContext context, int orderId) async {
    if (isClosed) return;
    emit(DriverDetailsOrderScreenLoading());
    try {
      final order = await repository.getOrderDetails(orderId);
      if (isClosed) return;
      if (order == null) {
        emit(DriverDetailsOrderScreenError("Order already taken"));
        return;
      }

      final int driverWallet = await walletRepository.getDriverWallet();
      final requiredAmount =
          (order.expectedPrice * ConstThingsOfUser.percentageOfProfit).toInt();
      if (driverWallet < requiredAmount) {
        await ConfirmationDialog.show(
          context: context,
          title: "Insufficient Balance",
          content: "Please recharge your wallet to accept this order.",
          confirmText: "Recharge Now",
          onConfirm: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.driverHomeScreen,
              (route) => false,
            );
          },
        );
        return;
      }

      emit(DriverDetailsOrderScreenSuccess(order));
    } catch (e) {
      if (!isClosed) emit(DriverDetailsOrderScreenError(e.toString()));
    }
  }

  Future<void> deleteOrder(int orderId) async {
    if (isClosed) return;
    emit(DriverDetailsOrderScreenLoading());
    try {
      final deleted = await repository.deleteOrder(orderId);
      if (isClosed) return;
      if (deleted) {
        emit(DriverDetailsOrderScreenDeleted());
      } else {
        emit(DriverDetailsOrderScreenError("Failed to delete order"));
      }
    } catch (e) {
      if (!isClosed) emit(DriverDetailsOrderScreenError(e.toString()));
    }
  }
}
