import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:firebase_core/firebase_core.dart';
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

      try {
        final fcmToken = await _getFcmTokenIfAvailable();
        if (fcmToken != null) {
          await FirebaseFirestore.instance
              .collection('orderNotifications')
              .doc(orderId.toString()) 
              .set({
            'orderId': orderId,
            'fcmToken': fcmToken,
            'createdAt': DateTime.now().toIso8601String(),
          });
        } else {
          // Unable to capture an FCM token (typically when the user denied notification permission on iOS).
          print('⚠️ Skipping FCM registration for order $orderId because no token is available.');
        }
      } on FirebaseException catch (error) {
        // If FCM token fetching fails, continue without blocking order creation.
        print('⚠️ Failed to register FCM token for order $orderId: ${error.code} ${error.message}');
      }

      return orderModel;
    } on DioException catch (error) {
      throw DioExceptionHandler.handleDioError(error);
    }
  }

  Future<String?> _getFcmTokenIfAvailable() async {
    final messaging = FirebaseMessaging.instance;

    final isApplePlatform = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);

    if (isApplePlatform) {
      // Wait for the APNS token to become available; this is required before fetching the FCM token on Apple platforms.
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken == null) {
        // Trigger the permission prompt again if the user has not responded yet.
        await messaging.requestPermission();
        for (var attempt = 0; attempt < 5 && apnsToken == null; attempt++) {
          await Future.delayed(const Duration(milliseconds: 500));
          apnsToken = await messaging.getAPNSToken();
        }
      }

      if (apnsToken == null) {
        return null;
      }
    }

    try {
      return await messaging.getToken();
    } on FirebaseException catch (error) {
      // `firebase_messaging/apns-token-not-set` is expected when notifications are disabled.
      print('⚠️ Failed to fetch FCM token: ${error.code} ${error.message}');
      return null;
    }
  }
}
