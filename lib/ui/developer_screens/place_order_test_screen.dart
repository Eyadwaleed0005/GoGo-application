import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceOrderTestScreen extends StatelessWidget {
  const PlaceOrderTestScreen({super.key});

  Future<void> placeOrder() async {
    try {
      final orderData = {
        "userId": "87a8568b-5e79-43a8-b9f6-dac75882e737",
        "date": DateTime.now().toIso8601String(),
        "from": "Cairo Tower",
        "to": "Nasr City",
        "fromLatLng": {"lat": 30.0456, "lng": 31.2243},
        "toLatLng": {"lat": 30.0715, "lng": 31.3136},
        "expectedPrice": 50,
        "type": "ride",
        "distance": 10,
        "notes": "No luggage",
        "noPassengers": 1,
        "userName": "Real User",
        "userPhone": "+201234567890",
        "userImage": "https://i.pravatar.cc/150?img=1"
      };

      // 1️⃣ إرسال الأوردر للباك
      final response = await Dio().post(
        'https://in-drive.runasp.net/api/Orders',
        data: orderData,
      );

      final orderId = response.data['id']?.toString();
      if (orderId == null) {
        print("❌ Failed to get orderId from backend");
        return;
      }
      print("✅ Order ID from backend: $orderId");

      // 2️⃣ جلب FCM Token من الجهاز
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        print("❌ Failed to get FCM Token from device");
        return;
      }
      print("✅ FCM Token: $fcmToken");

      // 3️⃣ حفظه في Firestore مع orderId
      await FirebaseFirestore.instance
          .collection('orderNotifications')
          .doc(orderId)
          .set({
        'orderId': orderId,
        'fcmToken': fcmToken,
        'createdAt': DateTime.now().toIso8601String(),
      });

      print("✅ FCM Token saved with Order ID $orderId successfully!");
    } catch (e) {
      print("❌ Error placing order or saving FCM: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Place Order")),
      body: Center(
        child: ElevatedButton(
          onPressed: placeOrder,
          child: const Text("Place Order & Save FCM"),
        ),
      ),
    );
  }
}
