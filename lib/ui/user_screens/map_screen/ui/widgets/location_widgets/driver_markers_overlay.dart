import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_places_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit/location_service_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit/location_service_state.dart';
import 'dart:ui' as ui;

class DriverMarkersOverlay extends StatelessWidget {
  const DriverMarkersOverlay({super.key});

  /// تحويل صورة PNG من assets إلى BitmapDescriptor
  Future<BitmapDescriptor> _getMarkerFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List bytes = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  /// إضافة ماركر لكل السائقين
  Future<void> _addDriverMarkers(
    MapCubit mapCubit,
    List<DriverPlace> drivers,
  ) async {
    final markerIcon = await _getMarkerFromAsset(
      'assets/images/taxi2.png',
      180,
    );

    final markers = drivers.map((driver) {
      return Marker(
        markerId: MarkerId(driver.driverName),
        position: LatLng(driver.lat, driver.lng),
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: driver.driverName,
        ), // اسم السائق فوق الماركر
        anchor: const Offset(0.5, 1.0),
      );
    }).toSet();

    mapCubit.updateDriversMarkers(markers);
  }

  /// إضافة ماركر لسائق واحد
  Future<void> _addSingleDriverMarker(
    MapCubit mapCubit,
    DriverPlace driver,
  ) async {
    final markerIcon = await _getMarkerFromAsset(
      'assets/images/taxi2.png',
      180,
    );

    final marker = Marker(
      markerId: MarkerId(driver.driverName),
      position: LatLng(driver.lat, driver.lng),
      icon: markerIcon,
      infoWindow: InfoWindow(title: driver.driverName),
      anchor: const Offset(0.5, 1.0),
    );

    mapCubit.updateDriversMarkers({marker});
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return BlocListener<LocationServiceCubit, LocationServiceState>(
      listener: (context, state) async {
        if (state is LocationServiceWithDrivers) {
          await _addDriverMarkers(mapCubit, state.drivers);
        } else if (state is LocationServiceWithSingleDriver) {
          await _addSingleDriverMarker(mapCubit, state.driver);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
