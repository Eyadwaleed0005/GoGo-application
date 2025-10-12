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

      List<GetAllOrdersModel> filteredOrders = [];

      // ✅ فلترة الطلبات حسب نوع العربية
      if (carBrand?.toLowerCase() == 'taxi') {
        filteredOrders = orders
            .where((o) => o.carType.toLowerCase() == 'taxi')
            .toList();
      } else if (carBrand?.toLowerCase() == 'scooter') {
        filteredOrders = orders
            .where((o) => o.carType.toLowerCase() == 'scooter')
            .toList();
      } else {
        filteredOrders = orders.where((o) {
          if (o.carType.toLowerCase() == 'taxi' ||
              o.carType.toLowerCase() == 'scooter') {
            return false;
          }

          if (o.pinkMode == true) {
            return gender?.toLowerCase() == 'female';
          } else {
            return true;
          }
        }).toList();
      }
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
}
