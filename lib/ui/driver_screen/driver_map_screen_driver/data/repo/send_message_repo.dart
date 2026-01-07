import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/const/const_things_of_admin.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/routes/app_images_routes.dart';

class SendMessageRepo {
  final String projectId;

  SendMessageRepo({required this.projectId});

  Future<String?> getOrderId() async {
    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getInt(SharedPreferenceKeys.orderId);
    return orderId?.toString();
  }

  Future<String?> getFcmToken(String orderId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('orderNotifications')
          .doc(orderId)
          .get();

      if (!doc.exists) return null;

      final data = doc.data();
      final token = data?['fcmToken'];

      if (token is String && token.trim().isNotEmpty) {
        return token.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<ServiceAccountCredentials> _loadCredentials() async {
    final jsonString = await rootBundle.loadString(AppImage().notificationKey);
    return ServiceAccountCredentials.fromJson(json.decode(jsonString));
  }

  Future<String> _getAccessToken() async {
    final credentials = await _loadCredentials();
    final client = await clientViaServiceAccount(
      credentials,
      [EndPoints.fcmScope],
    );
    return client.credentials.accessToken.data;
  }

  Future<bool> sendNotification({required String token}) async {
    final accessToken = await _getAccessToken();
    final url = EndPoints.sendFcmMessage(projectId);

    final message = {
      "message": {
        "token": token,
        "notification": {
          "title": ConstThingsOfUser.notificationTitle,
          "body": ConstThingsOfUser.notificationBody,
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },
      },
    };

    try {
      final res = await DioHelper.dio.post(
        url,
        data: message,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
        ),
      );

      return res.statusCode == 200 || res.statusCode == 201;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
