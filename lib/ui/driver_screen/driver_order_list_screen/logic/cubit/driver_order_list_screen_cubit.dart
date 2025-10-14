import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
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

    // ✅ يشوف هل السواق أونلاين ولا لا
    final isActive = await SharedPreferencesHelper.getBool(
      key: SharedPreferenceKeys.driverActive,
    );

    if (isActive != true) {
      if (isClosed) return;
      emit(DriverOrderListScreenInactive());
      return;
    }

    try {
      // ✅ يجيب نوع العربية والجندر من التخزين المحلي
      final carBrand = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.carBrand,
      );
      final gender = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.gender,
      );

      // ✅ يجيب كل الأوردرات
      final orders = await repository.getAllOrders();
      final driverCarType = _resolveDriverCarType(carBrand);
      final driverGender = gender?.trim().toLowerCase() ?? '';
      final isFemaleDriver = driverGender == 'female';

      final filteredOrders = orders.where((order) {
        final orderCarType = _normalizeOrderCarType(order.carType);
        if (order.pinkMode == true && !isFemaleDriver) {
          return false;
        }

        if (driverCarType == 'taxi') {
          return orderCarType == 'taxi';
        }

        if (driverCarType == 'scooter') {
          return orderCarType == 'scooter';
        }

        if (orderCarType == 'taxi' || orderCarType == 'scooter') {
          return false;
        }

        return true;
      }).toList();
      final pendingOrders = filteredOrders
          .where((order) => (order.status ?? '').toLowerCase() == 'pending')
          .toList()
          .reversed
          .toList();

      if (isClosed) return;
      emit(DriverOrderListScreenSuccess(List.unmodifiable(pendingOrders)));
    } catch (error) {
      if (isClosed) return;
      emit(DriverOrderListScreenError(error.toString()));
    }
  }

  String _resolveDriverCarType(String? rawCarBrand) {
    final normalized = rawCarBrand?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return 'car';
    }
    if (normalized.contains('taxi')) {
      return 'taxi';
    }
    if (normalized.contains('scooter') || normalized.contains('scotter')) {
      return 'scooter';
    }
    if (normalized == 'car' || normalized == 'other') {
      return 'car';
    }
    return 'car';
  }

  String _normalizeOrderCarType(String? rawCarType) {
    final normalized = rawCarType?.trim().toLowerCase() ?? '';
    if (normalized == 'scotter') {
      return 'scooter';
    }
    return normalized;
  }
}
