// map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/user_order_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit/location_service_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit/location_service_state.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_input_panel_cubit/cubit/route_input_panel_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/routes/app_routes.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_cubit/location_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_cubit/location_state.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_cubit/search_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/review_cubit/review_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_button.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_error_widget.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/network_banner.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/route_input_panel.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/map_veiw.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/rating_widgets/approved_trip_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();

  late final RouteCubit _routeCubit;
  late final MapCubit _mapCubit;
  late final SearchCubit _searchCubit;
  late final LocationCubit _locationCubit;
  late final LocationServiceCubit _locationServiceCubit;
  late final ReviewCubit _reviewCubit;

  String? _orderStatus;

  @override
  void initState() {
    super.initState();
    _routeCubit = RouteCubit(MapRepository());
    _mapCubit = MapCubit(MapRepository());
    _searchCubit = SearchCubit(MapRepository());
    _locationCubit = LocationCubit();
    _locationServiceCubit = LocationServiceCubit()..checkLocationService();
    _reviewCubit = ReviewCubit(UserOrderRepository());

    _checkOrderStatus();

    Future.delayed(const Duration(milliseconds: 300), () {
      _routeCubit.loadSavedRoute();
    });
  }

  Future<void> _checkOrderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final orderStatus = prefs.getString(SharedPreferenceKeys.orderStatus);
    setState(() {
      _orderStatus = orderStatus;
    });

    if (orderStatus == "pending") {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.waitingOrderStatusScreen,
      );
    }
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    _routeCubit.close();
    _mapCubit.close();
    _searchCubit.close();
    _locationCubit.close();
    _locationServiceCubit.close();
    _reviewCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _locationCubit),
        BlocProvider.value(value: _routeCubit),
        BlocProvider.value(value: _mapCubit),
        BlocProvider.value(value: _searchCubit),
        BlocProvider.value(value: _locationServiceCubit),
        BlocProvider.value(value: _reviewCubit),
        BlocProvider(
          create: (_) => RouteInputPanelCubit(
            routeCubit: _routeCubit,
            mapCubit: _mapCubit,
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  MapView(
                    fromController: fromController,
                    isTripApproved:
                        _orderStatus == "approved" || _orderStatus == "approve",
                  ),

                  Positioned(
                    top: 10.h,
                    left: 5.w,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.sp,
                        color: ColorPalette.textDark,
                      ),
                    ),
                  ),

                  /// ⬅️ نعرض RouteInputPanel فقط عندما لا يوجد طلب نشط
                  if (_orderStatus == null || _orderStatus == "cancel")
                    RouteInputPanel(
                      fromController: fromController,
                      toController: toController,
                    ),

                  /// ⬅️ في حالة وجود رحلة حالية Approved
                  if (_orderStatus == "approved" || _orderStatus == "approve")
                    const ApprovedTripPanel(),

                  const NetworkBanner(),

                  /// ⬅️ زر تحديد الموقع الحالي
                  Positioned(
                    bottom: 205.h,
                    right: 16.w,
                    child: BlocListener<LocationCubit, LocationState>(
                      listener: (context, state) {
                        if (state is LocationLoaded) {
                          final mapCubit = context.read<MapCubit>();
                          mapCubit.moveCamera(state.currentLocation);
                          mapCubit.showPinAt(
                            state.currentLocation,
                            "Lat: ${state.latitude}, Lng: ${state.longitude}",
                          );
                        }
                      },
                      child: LocationButton(
                        onPressed: () {
                          context.read<LocationCubit>().getCurrentLocation();
                        },
                      ),
                    ),
                  ),

                  /// ⬅️ في حال كانت خدمة الموقع مغلقة
                  BlocBuilder<LocationServiceCubit, LocationServiceState>(
                    builder: (context, state) {
                      if (state is LocationServiceDisabled) {
                        return const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LocationErrorWidget(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
