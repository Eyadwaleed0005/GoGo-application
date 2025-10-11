import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/widgets/custom_back_button.dart';
import 'package:gogo/ui/driver_screen/show_trip_on_map_screen/logic/show_trip_cubit.dart';
import 'package:gogo/ui/driver_screen/show_trip_on_map_screen/ui/widgets/TripInfoPanel.dart';
import 'package:gogo/ui/driver_screen/show_trip_on_map_screen/ui/widgets/show_trip_on_map_skeleton.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class ShowTripOnMapScreen extends StatefulWidget {
  final double customerLat;
  final double customerLng;
  final double destinationLat;
  final double destinationLng;

  const ShowTripOnMapScreen({
    super.key,
    required this.customerLat,
    required this.customerLng,
    required this.destinationLat,
    required this.destinationLng,
  });

  @override
  State<ShowTripOnMapScreen> createState() => _ShowTripOnMapScreenState();
}

class _ShowTripOnMapScreenState extends State<ShowTripOnMapScreen> {
  GoogleMapController? _mapController;

  void _loadTrip() {
    context.read<ShowTripCubit>().showTrip(
          customerLat: widget.customerLat,
          customerLng: widget.customerLng,
          destinationLat: widget.destinationLat,
          destinationLng: widget.destinationLng,
        );
  }

  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  Future<void> _fitToPolylines(ShowTripLoadedMulti state) async {
    final allPoints = [
      ...state.polyline1.points,
      ...state.polyline2.points,
    ];

    if (allPoints.isEmpty || _mapController == null) return;

    final bounds = context.read<ShowTripCubit>().calculateBounds(allPoints);

    await Future.delayed(const Duration(milliseconds: 400));
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundColor,
      body: BlocConsumer<ShowTripCubit, ShowTripState>(
        listener: (context, state) async {
          if (state is ShowTripLoadedMulti && _mapController != null) {
            await _fitToPolylines(state);
          }
        },
        builder: (context, state) {
          if (state is ShowTripLoading) {
            return Stack(
              children: [
                const ShowTripOnMapSkeleton(),
                const CustomBackButton(),
              ],
            );
          }
          if (state is ShowTripError || state is ShowTripInitial) {
            final message = state is ShowTripError
                ? state.message
                : "loading_error".tr();
            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyles.font10redSemiBold(),
                        ),
                        verticalSpace(18),
                        ElevatedButton(
                          onPressed: _loadTrip,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.mainColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 24.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                          ),
                          child: Text(
                            "retry".tr(),
                            style: TextStyles.font10Blackbold(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const CustomBackButton(),
              ],
            );
          }
          if (state is ShowTripLoadedMulti) {
            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(state.driverLat, state.driverLng),
                    zoom: 10,
                  ),
                  onMapCreated: (controller) async {
                    _mapController = controller;
                    await _fitToPolylines(state);
                  },
                  polylines: {state.polyline1, state.polyline2},
                  markers: {
                    Marker(
                      markerId: const MarkerId('driver'),
                      position: LatLng(state.driverLat, state.driverLng),
                      icon: state.driverIcon,
                    ),
                    Marker(
                      markerId: const MarkerId('customer'),
                      position: LatLng(state.customerLat, state.customerLng),
                      icon: state.customerIcon,
                    ),
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: LatLng(
                        state.destinationLat,
                        state.destinationLng,
                      ),
                      icon: state.destinationIcon,
                    ),
                  },
                ),
                const CustomBackButton(),
                TripInfoPanel(
                  driverToCustomerDistance: state.distance1Km,
                  driverToCustomerTime: state.duration1Min,
                  customerToDestinationDistance: state.distance2Km,
                  customerToDestinationTime: state.duration2Min,
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
