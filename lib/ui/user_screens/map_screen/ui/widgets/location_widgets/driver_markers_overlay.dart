import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_places_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

class DriverMarkersOverlay extends StatelessWidget {
  const DriverMarkersOverlay({super.key});

  Future<void> _addDriverMarkers(
    MapCubit mapCubit,
    List<DriverPlace> drivers,
  ) async {
    if (mapCubit.mapboxMap == null) {
      debugPrint("❌ MapboxMap is NULL");
      return;
    }

    // إنشاء مدير الماركرات لو مش موجود
    mapCubit.driverAnnotationManager ??= await mapCubit.mapboxMap!.annotations
        .createPointAnnotationManager();

    // مسح القديم
    await mapCubit.driverAnnotationManager!.deleteAll();

    debugPrint("🟢 عندنا ${drivers.length} سواق");

    for (var driver in drivers) {
      try {
        final annotationOptions = mb.PointAnnotationOptions(
          geometry: mb.Point(coordinates: mb.Position(driver.lng, driver.lat)),
          iconImage: "airport-15", // أيقونة موجودة في style
          iconSize: 4.0, // حجم الماركر
          textField: driver.driverName,
          textSize: 12.0,
          textOffset: [0, 2.0], // يحرك الاسم فوق الماركر
        );
        await mapCubit.driverAnnotationManager!.create(annotationOptions);

        await mapCubit.driverAnnotationManager!.create(annotationOptions);
        debugPrint("✅ اتضاف الماركر بتاع ${driver.driverName}");
      } catch (e) {
        debugPrint("❌ Failed to add marker: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return BlocBuilder<LocationServiceCubit, LocationServiceState>(
      builder: (context, state) {
        if (state is LocationServiceWithDrivers) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _addDriverMarkers(mapCubit, state.drivers);
          });
        }
        return const SizedBox.shrink();
      },
    );
  }
}
