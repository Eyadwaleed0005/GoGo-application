import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/data/repo/get_all_orders_repository.dart';
import 'package:meta/meta.dart';

part 'driver_order_list_screen_state.dart';

class DriverOrderListScreenCubit extends Cubit<DriverOrderListScreenState> {
  final GetAllOrdersRepository repository;

  DriverOrderListScreenCubit({required this.repository})
      : super(DriverOrderListScreenInitial());

  Future<void> fetchOrders() async {
    if (isClosed) return; 
    emit(DriverOrderListScreenLoading());

    final isActive = await SharedPreferencesHelper.getBool(
      key: SharedPreferenceKeys.driverActive,
    );

    if (isActive != true) {
      if (isClosed) return;
      emit(DriverOrderListScreenInactive());
      return;
    }

    try {
      final orders = await repository.getAllOrders();
      if (isClosed) return;
      emit(DriverOrderListScreenSuccess(List.unmodifiable(orders))); // ✅
    } catch (error) {
      if (isClosed) return;
      emit(DriverOrderListScreenError(error.toString()));
    }
  }

  void removeOrderLocally(int orderId) {
    if (state is DriverOrderListScreenSuccess) {
      final currentState = state as DriverOrderListScreenSuccess;
      final updatedList =
          currentState.orders.where((order) => order.id != orderId).toList();

      if (isClosed) return;
      emit(DriverOrderListScreenSuccess(List.unmodifiable(updatedList))); // ✅
    }
  }
}
