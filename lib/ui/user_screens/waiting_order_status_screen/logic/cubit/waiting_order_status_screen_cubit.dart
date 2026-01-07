import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gogo/ui/user_screens/waiting_order_status_screen/data/repo/get_order_by_id_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';

part 'waiting_order_status_screen_state.dart';

class WaitingOrderStatusScreenCubit extends Cubit<WaitingOrderStatusScreenState> {
  final GetOrderByIdRepository repository;

  Timer? _pollingTimer;
  bool _disposed = false;

  WaitingOrderStatusScreenCubit(this.repository)
      : super(WaitingOrderStatusScreenInitial());

  void startTrackingOrder() async {
    if (_disposed) return;
    emit(WaitingOrderStatusLoading());

    try {
      final order = await repository.getOrderById();
      if (_disposed) return;

      if (order == null) {
        await _saveOrderStatus("no_driver");
        if (!_disposed) emit(WaitingOrderNoDriverFound());
        stopTracking();
        return;
      }

      await _handleOrderStatus(order);

      _pollingTimer?.cancel();
      _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
        if (_disposed) return;
        await _checkOrderStatus();
      });
    } catch (e) {
      if (!_disposed) emit(WaitingOrderStatusError(e.toString()));
    }
  }

  Future<void> _checkOrderStatus() async {
    if (_disposed) return;

    try {
      final order = await repository.getOrderById();
      if (_disposed) return;

      if (order == null) {
        await _saveOrderStatus("no_driver");
        if (!_disposed) emit(WaitingOrderNoDriverFound());
        stopTracking();
        return;
      }

      await _handleOrderStatus(order);
    } catch (e) {
      if (!_disposed) emit(WaitingOrderStatusError(e.toString()));
    }
  }

  Future<void> _handleOrderStatus(GetAllOrdersModel order) async {
    if (_disposed) return;

    if (order.status == "approve") {
      await _saveOrderStatus("approve");
      if (!_disposed) emit(WaitingOrderApproved(order));
      stopTracking();
    } else if (order.status == "pending") {
      await _saveOrderStatus("pending");
      if (!_disposed) emit(WaitingOrderStatusLoaded(order));
    } else {
      await _saveOrderStatus("cancel");
      if (!_disposed) emit(WaitingOrderCancelled(order));
      stopTracking();
    }
  }

  Future<void> cancelOrder() async {
    if (_disposed) return;

    try {
      final response = await repository.clearOrder();
      if (_disposed) return;

      if (response.success) {
        await _saveOrderStatus("cancel");
        if (!_disposed) emit(WaitingOrderCancelledManually());
        stopTracking();
      } else {
        if (!_disposed) emit(WaitingOrderStatusError(response.message));
      }
    } catch (e) {
      if (!_disposed) emit(WaitingOrderStatusError(e.toString()));
    }
  }

  Future<void> clearLocalOrderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceKeys.orderStatus);
  }

  Future<void> _saveOrderStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferenceKeys.orderStatus, status);
  }

  void stopTracking() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    _disposed = true;
    stopTracking();
    return super.close();
  }
}
