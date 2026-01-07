import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/user_drivers_socket_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/user_drivers_socket_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_places_model.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit/map_cubit.dart';
import 'dart:ui' as ui;

class DriverMarkersOverlay extends StatelessWidget {
  const DriverMarkersOverlay({super.key});

  Future<BitmapDescriptor> _getMarkerFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List bytes = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!
        .buffer
        .asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<Set<Marker>> _buildMarkers(List<DriverPlace> drivers) async {
    final icon = await _getMarkerFromAsset('assets/images/taxi2.png', 180);

    return drivers.map((d) {
      return Marker(
        markerId: MarkerId(d.driverId.toString()),
        position: LatLng(d.lat, d.lng),
        icon: icon,
        infoWindow: InfoWindow(title: d.driverName),
        anchor: const Offset(0.5, 1.0),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();

    return BlocListener<UserDriversSocketCubit, UserDriversSocketState>(
      listener: (context, state) async {
        if (state is UserDriversSocketDriversUpdated) {
          final markers = await _buildMarkers(state.drivers);
          mapCubit.updateDriversMarkers(markers);

          if (state.followDriverId != null && state.drivers.isNotEmpty) {
            final d = state.drivers.first;
            await mapCubit.moveCamera(
              LatLng(d.lat, d.lng),
              zoom: 17,
              tilt: 45,
              bearing: 0,
            );
          }
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
