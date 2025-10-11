import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/passenger_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOrderRepository {
  Future<GetAllOrdersModel?> getOrderById() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderId = prefs.getInt(SharedPreferenceKeys.userOrderId);
      if (orderId == null) return null;

      final response = await DioHelper.getData(
        url: EndPoints.getOrderById(orderId),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final order = GetAllOrdersModel.fromJson(data);

        if (order.status != null) {
          await prefs.setString(SharedPreferenceKeys.orderStatus, order.status!);
        }
        if (order.driverId != null) {
          await prefs.setInt(SharedPreferenceKeys.driverIdTrip, order.driverId!);
        }

        return order;
      } else {
        return null;
      }
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  PassengerHistory mapOrderToPassengerHistory(GetAllOrdersModel order) {
    return PassengerHistory(
      userId: order.userId,
      from: order.from,
      to: order.to,
      price: order.expectedPrice,
      date: order.date,
      paymentMethod: order.paymentWay,   
      rideType: order.type,    
    );
  }

  Future<void> savePassengerHistory(GetAllOrdersModel order) async {
    final history = mapOrderToPassengerHistory(order);

    try {
      await DioHelper.postData(
        url: EndPoints.savePassengerHistory,
        data: history.toJson(),
      );
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  Future<void> saveCurrentOrderAsHistory() async {
    final order = await getOrderById();
    if (order != null) {
      await savePassengerHistory(order);
    }
  }
}
