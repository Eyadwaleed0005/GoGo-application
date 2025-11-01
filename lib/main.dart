import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/services/app_update_manager.dart';
import 'package:gogo/core/services/notification_service.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/ui/driver_waiting_list_screen.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/logic/cubit/driver_location_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  unawaited(NotificationService().init());
  DioHelper.init(baseUrl: EndPoints.baseurl);
  const storage = FlutterSecureStorage();
  String? savedLang = await storage.read(
    key: SharedPreferenceKeys.selectedLanguage,
  );
  Locale initialLocale =
      savedLang != null ? Locale(savedLang) : const Locale('en');
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: initialLocale,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DriverLocationCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateManager.checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(257, 557),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: ColorPalette.backgroundColor,
          ),
          initialRoute: AppRoutes.adminHomeScreen,
          onGenerateRoute: AppRoutes.generateRoute,
          navigatorObservers: [routeObserver],
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}
