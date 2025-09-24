import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/driver_save_trip_helper_trips.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/confirmation_dialog.dart';
import 'package:gogo/ui/driver_screen/driver_home_screen/ui/driver_home_screen.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/model/ride_model.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_ride_repository.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_trip_in_history_repository.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/logic/cubit/driver_amount_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/ui/widgets/ConnectionStatusBar.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/ui/widgets/retry_button.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/ui/widgets/driver_map_view.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/ui/widgets/trip_action_card.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/logic/trip_action_card_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_amount_repository.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({super.key});

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  bool _isTripStarted = false;
  RideModel? _ride;
  double? customerLat;
  double? customerLng;
  double? destinationLat;
  double? destinationLng;
  String? userPhone;
  String? customerName;
  late TripActionCardCubit _tripCubit;
  late DriverAmountCubit _driverAmountCubit;

  @override
  void initState() {
    super.initState();
    _tripCubit = TripActionCardCubit(
      DriverRideRepository(),
      DriverTripSaveHistory(),
    );
    _driverAmountCubit = DriverAmountCubit(
      repository: DriverAmountRepository(),
    );
    _loadTripData();
  }

  Future<void> _loadTripData() async {
    final tripData = await SharedPreferencesHelperTrips.getTripData();
    if (tripData != null) {
      setState(() {
        customerLat = tripData['customerLat'];
        customerLng = tripData['customerLng'];
        destinationLat = tripData['destinationLat'];
        destinationLng = tripData['destinationLng'];
        userPhone = tripData['userPhone'];
        customerName = tripData['customerName'];
        _isTripStarted = tripData['isOnTripTwo'] ?? false;
      });

      _tripCubit.startTracking(
        toLat: _isTripStarted ? destinationLat! : customerLat!,
        toLng: _isTripStarted ? destinationLng! : customerLng!,
        userPhone: userPhone!,
        isDestination: _isTripStarted,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (customerLat == null ||
        customerLng == null ||
        destinationLat == null ||
        destinationLng == null ||
        userPhone == null ||
        customerName == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            color: ColorPalette.mainColor,
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<TripActionCardCubit>.value(value: _tripCubit),
        BlocProvider<DriverAmountCubit>.value(value: _driverAmountCubit),
      ],
      child: BlocBuilder<TripActionCardCubit, TripActionCardState>(
        builder: (context, state) {
          if (state is TripActionCardLoading) {
            return Scaffold(
              backgroundColor: ColorPalette.backgroundColor,
              body: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: ColorPalette.mainColor,
                ),
              ),
            );
          }
          if (state is TripActionCardError) {
            return Scaffold(
              backgroundColor: ColorPalette.backgroundColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyles.font10redSemiBold(),
                    ),
                    verticalSpace(18),
                    RetryButton(
                      onPressed: () {
                        _tripCubit.startTracking(
                          toLat: state.isDestination
                              ? destinationLat!
                              : customerLat!,
                          toLng: state.isDestination
                              ? destinationLng!
                              : customerLng!,
                          userPhone: userPhone!,
                          isDestination: state.isDestination,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TripActionCardUpdated) {
            _ride = state.ride;
            _isTripStarted = state.isDestination;
          }
          if (_ride == null) {
            Future.microtask(() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
                (route) => false,
              );
            });
            return Scaffold(
              backgroundColor: ColorPalette.backgroundColor,
              body: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: ColorPalette.mainColor,
                ),
              ),
            );
          }
          return Scaffold(
            body: Stack(
              children: [
                DriverMapView(ride: _ride, isTripStarted: _isTripStarted),
                TripActionCard(
                  isTripStarted: _isTripStarted,
                  customerName: customerName!,
                  userPhone: userPhone!,
                  distance: _ride!.distanceText,
                  time: _ride!.durationText,
                  onStartTrip: () async {
                    _tripCubit.startTracking(
                      toLat: destinationLat!,
                      toLng: destinationLng!,
                      userPhone: userPhone!,
                      isDestination: true,
                    );
                    await SharedPreferencesHelperTrips.updateTripStage(
                      isOnTrip: false,
                      isOnTripTwo: true,
                    );
                    setState(() {
                      _isTripStarted = true;
                    });
                  },

                  onEndTrip: () async {
                    _tripCubit.stopTracking();

                    final cubit = context.read<DriverAmountCubit>();
                    await cubit.deductTripAmount();
                    final state = cubit.state;

                    if (state is DriverAmountSuccess) {
                      try {
                        await _tripCubit.saveTripToHistory();
                        await SharedPreferencesHelperTrips.clearTripData();
                        setState(() {
                          _isTripStarted = false;
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverHomeScreen(),
                          ),
                          (route) => false,
                        );

                        // حوار التأكيد مع الترجمة
                        Future.delayed(const Duration(milliseconds: 300), () {
                          ConfirmationDialog.show(
                            context: context,
                            title: tr("trip_completed_title"),
                            confirmText: tr("ok"),
                            content: tr(
                              "trip_completed_msg",
                              namedArgs: {
                                "amount": state.deductedAmount.toString(),
                              },
                            ),
                            onConfirm: () {},
                            showCancel: false,
                          );
                        });
                      } catch (e) {
                        await ConfirmationDialog.show(
                          context: context,
                          title: tr("error_title"),
                          confirmText: tr("retry"),
                          content: tr("save_trip_error"),
                          onConfirm: () async {
                            await _tripCubit.saveTripToHistory();
                          },
                        );
                      }
                    } else if (state is DriverAmountError) {
                      await ConfirmationDialog.show(
                        context: context,
                        title: tr("error_title"),
                        confirmText: tr("retry"),
                        content: state.message,
                        onConfirm: () async {
                          await cubit.deductTripAmount();
                        },
                      );
                    }
                  },
                  onCall: () {
                    context.read<TripActionCardCubit>().makePhoneCall(
                      userPhone!,
                    );
                  },
                  onMessage: () {
                    context.read<TripActionCardCubit>().openWhatsAppChat(
                      userPhone!.replaceAll("+", ""),
                    );
                  },
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: ConnectionStatusBar(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tripCubit.close();
    _driverAmountCubit.close();
    super.dispose();
  }
}
