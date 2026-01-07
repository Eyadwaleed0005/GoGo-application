import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_ride_repository.dart';
import 'package:gogo/ui/driver_screen/show_trip_on_map_screen/logic/show_trip_cubit.dart';
import 'package:gogo/ui/driver_screen/show_trip_on_map_screen/ui/show_trip_on_map_screen.dart';

class ShowTripButton extends StatelessWidget {
  final double customerLat;
  final double customerLng;
  final double destinationLat;
  final double destinationLng;

  const ShowTripButton({
    super.key,
    required this.customerLat,
    required this.customerLng,
    required this.destinationLat,
    required this.destinationLng,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ColorPalette.mainColor,
      child:  Icon(Icons.map, color: ColorPalette.black),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ShowTripCubit(DriverRideRepository()),
              child: ShowTripOnMapScreen(
                customerLat: customerLat,
                customerLng: customerLng,
                destinationLat: destinationLat,
                destinationLng: destinationLng,
              ),
            ),
          ),
        );
      },
    );
  }
}
