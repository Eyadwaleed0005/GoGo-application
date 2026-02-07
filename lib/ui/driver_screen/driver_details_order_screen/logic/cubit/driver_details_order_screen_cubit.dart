import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/const/const_things_of_admin.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/widgets/confirmation_dialog.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/data/repo/order_details_repository.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/repo/driver_wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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
      if (!isClosed) {
        emit(DriverDetailsOrderScreenError("Error: ${e.toString()}"));
      }
    }
  }

  Future<void> acceptOrder(BuildContext context, int orderId) async {
    if (isClosed) return;
    emit(DriverDetailsOrderScreenLoading());

    try {
      final order = await repository.getOrderDetails(orderId);
      if (isClosed) return;

      if (order == null) {
        emit(DriverDetailsOrderScreenError("Order not found"));
        return;
      }

      // ✅ لازم الأوردر يكون Pending
      final orderStatus = order.status?.toLowerCase().trim();
      if (orderStatus != 'pending') {
        emit(DriverDetailsOrderScreenError("order_no_longer_available".tr()));
        return;
      }

      // ✅ تحقق من رصيد السائق
      final int driverWallet = await walletRepository.getDriverWallet();
      final requiredAmount =
          (order.expectedPrice * ConstThingsOfUser.percentageOfProfit).toInt();

      if (driverWallet < requiredAmount) {
        await ConfirmationDialog.show(
          context: context,
          title: "insufficient_balance".tr(),
          content: "recharge_wallet_message".tr(),
          confirmText: "recharge_now".tr(),
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
      if (!isClosed) {
        emit(DriverDetailsOrderScreenError("Error: ${e.toString()}"));
      }
    }
  }

  Future<void> approveOrder(int orderId) async {
    if (isClosed) return;
    emit(DriverDetailsOrderScreenLoading());

    try {
      final currentOrder = await repository.getOrderDetails(orderId);
      if (isClosed) return;

      if (currentOrder == null) {
        emit(DriverDetailsOrderScreenError("Order not found"));
        return;
      }

      final orderStatus = currentOrder.status?.toLowerCase().trim();
      if (orderStatus != 'pending') {
        emit(DriverDetailsOrderScreenError("order_no_longer_available".tr()));
        return;
      }

      final driverIdStr = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.driverId,
      );
      final driverId = int.tryParse(driverIdStr ?? '') ?? 0;

      final orderData = {
        "orderId": orderId,
        "driverid": driverId,
        "status": "approve",
      };

      final updatedOrder = await repository.updateOrder(orderData);

      if (isClosed) return;
      if (updatedOrder != null) {
        emit(DriverDetailsOrderScreenSuccess(updatedOrder));
      } else {
        emit(DriverDetailsOrderScreenError("Failed to approve order"));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DriverDetailsOrderScreenError(e.toString()));
      }
    }
  }
}
