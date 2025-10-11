import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';

class OrdersRepository {
  static const String userOrderId = 'userOrderId'; 

  Future<GetAllOrdersModel?> createOrder(GetAllOrdersModel order) async {
    try {
      final response = await DioHelper.postData(
        url: EndPoints.createOrder,
        data: order.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final orderModel = GetAllOrdersModel.fromJson(data);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(userOrderId, orderModel.id); 
        return orderModel;
      } else {
        return null;
      }
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  Future<GetAllOrdersModel?> createOrderWithFCM(GetAllOrdersModel order) async {
    try {
      final response = await DioHelper.postData(
        url: EndPoints.createOrder,
        data: order.toJson(),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) return null;

      final orderModel = GetAllOrdersModel.fromJson(data);
      final orderId = orderModel.id;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(userOrderId, orderId); 

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await FirebaseFirestore.instance
            .collection('orderNotifications')
            .doc(orderId.toString()) 
            .set({
          'orderId': orderId,
          'fcmToken': fcmToken,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }

      return orderModel;
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    } catch (e) {
      throw Exception("Failed to create order with FCM: $e");
    }
  }
}
