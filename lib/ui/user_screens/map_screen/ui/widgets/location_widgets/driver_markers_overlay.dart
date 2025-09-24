import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_places_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

class DriverMarkersOverlay extends StatelessWidget {
  const DriverMarkersOverlay({super.key});

  Future<void> _addSingleDriverMarker(
    MapCubit mapCubit,
    DriverPlace driver,
  ) async {
    if (mapCubit.mapboxMap == null) return;

    mapCubit.driverAnnotationManager ??=
        await mapCubit.mapboxMap!.annotations.createPointAnnotationManager();

    await mapCubit.driverAnnotationManager!.deleteAll();

    final annotationOptions = mb.PointAnnotationOptions(
      geometry: mb.Point(coordinates: mb.Position(driver.lng, driver.lat)),
      iconImage: "car-15",
      iconSize: 3.5,
      textField: driver.driverName,
      textSize: 12.0,
      textOffset: [0, 2.0],
    );
    await mapCubit.driverAnnotationManager!.create(annotationOptions);
  }

  Future<void> _addDriverMarkers(
    MapCubit mapCubit,
    List<DriverPlace> drivers,
  ) async {
    if (mapCubit.mapboxMap == null) return;

    mapCubit.driverAnnotationManager ??=
        await mapCubit.mapboxMap!.annotations.createPointAnnotationManager();

    await mapCubit.driverAnnotationManager!.deleteAll();

    for (var driver in drivers) {
      final annotationOptions = mb.PointAnnotationOptions(
        geometry: mb.Point(coordinates: mb.Position(driver.lng, driver.lat)),
        iconImage: "car-15",
        iconSize: 3.5,
        textField: driver.driverName,
        textSize: 12.0,
        textOffset: [0, 2.0],
      );
      await mapCubit.driverAnnotationManager!.create(annotationOptions);
    }
  }
  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return BlocBuilder<LocationServiceCubit, LocationServiceState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (state is LocationServiceWithDrivers) {
            await _addDriverMarkers(mapCubit, state.drivers);
          } else if (state is LocationServiceWithSingleDriver) {
            await _addSingleDriverMarker(mapCubit, state.driver);
          }
        });
        return const SizedBox.shrink();
      },
    );
  }
}
