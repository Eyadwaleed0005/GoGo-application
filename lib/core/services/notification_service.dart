import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // قناة الإشعارات للأندرويد
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'arrival_channel', // id
    'رحلة الوصول', // name
    description: 'الإشعارات الخاصة بوصول السائق',
    importance: Importance.max,
  );

  Future<void> init() async {
    // اطلب صلاحيات من المستخدم
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print("🔔 Notification permission: ${settings.authorizationStatus}");

    // إعدادات Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);

    // إنشاء قناة للأندرويد
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // iOS فقط: لازم نتأكد إن APNs Token متوفر
    String? apnsToken = await _messaging.getAPNSToken();
    print("📱 APNs Token: $apnsToken");

    if (apnsToken == null) {
      print("⚠️ APNs token not ready yet, skipping FCM token fetch.");
    } else {
      // ✅ جلب FCM token بعد APNs جاهز
      final fcmToken = await _messaging.getToken();
      print("🔥 FCM Token: $fcmToken");
      // TODO: ابعته للسيرفر
    }

    // التعامل مع الرسائل في الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // التعامل مع الرسائل أثناء فتح التطبيق
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  // Background handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (message.notification != null) {
      final androidDetails = AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final localNotifications = FlutterLocalNotificationsPlugin();
      await localNotifications.show(
        0,
        message.notification!.title ?? "إشعار",
        message.notification!.body ?? "",
        platformDetails,
      );
    }
  }

  // Foreground handler
  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      final androidDetails = AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      _localNotifications.show(
        0,
        message.notification!.title ?? "إشعار",
        message.notification!.body ?? "",
        platformDetails,
      );
    }
  }
}
