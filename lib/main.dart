import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gogo/core/services/notification_service.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/ui/driver_waiting_list_screen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().init();
  mb.MapboxOptions.setAccessToken(EndPoints.accessToken);
  DioHelper.init();
  const FlutterSecureStorage().read(key: SecureStorageKeys.dummy);
  runApp(const MyApp());
  _checkLocationPermission();
}

Future<void> _checkLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    var result = await Permission.location.request();
    if (result.isGranted) {
    } else if (result.isPermanentlyDenied) {
      await openAppSettings();
    } else {
    }
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(257, 557),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: ColorPalette.backgroundColor,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splashScreen,
          onGenerateRoute: AppRoutes.generateRoute,
          navigatorObservers: [routeObserver],
        );
      },
    );
  }
}
