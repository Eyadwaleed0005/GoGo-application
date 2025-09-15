import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_state.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_button.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/location_widgets/location_error_widget.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/network_banner.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/route_input_panel.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/map_veiw.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocationCubit()),
        BlocProvider(create: (_) => RouteCubit(MapRepository())),
        BlocProvider(create: (_) => MapCubit(MapRepository())),
        BlocProvider(create: (_) => SearchCubit(MapRepository())),
        BlocProvider(
          create: (_) => LocationServiceCubit()..checkLocationService(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  MapView(fromController: fromController),
                  Positioned(
                    top: 10.h,
                    left: 5.w,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); 
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.sp,
                        color: ColorPalette.textDark,
                      ),
                    ),
                  ),
                  RouteInputPanel(
                    fromController: fromController,
                    toController: toController,
                  ),
                  const NetworkBanner(),
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
                  BlocBuilder<LocationServiceCubit, LocationServiceState>(
                    builder: (context, state) {
                      if (state is LocationServiceDisabled) {
                        return const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LocationErrorWidget(),
                        );
                      
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
