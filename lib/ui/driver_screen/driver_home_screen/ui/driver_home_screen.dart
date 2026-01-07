import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/widgets/custom_navigation_bar.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/logic/cubit/driver_history_screen_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/repo/driver_history_repository.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/driver_history_screen.dart';
import 'package:gogo/ui/driver_screen/driver_home_screen/ui/driver_home_screen_contant.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/logic/cubit/driver_order_list_screen_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/data/repo/get_all_orders_repository.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/ui/driver_order_list_screen.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/ui/driver_profile_screen.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/ui/driver_wallet_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = const [
      DriverHomeScreenContant(),
      DriverOrderListScreen(),
      DriverHistoryScreen(),
      DriverWalletScreen(),
      DriverProfileScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      var result = await Permission.location.request();
      if (result.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              DriverOrderListScreenCubit(repository: GetAllOrdersRepository())
                ..fetchOrders(),
        ),
        BlocProvider(
          create: (_) =>
              DriverHistoryScreenCubit(DriverHistoryRepository())
                ..fetchDriverHistory(),
        ),
      ],
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: CustomNavBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
