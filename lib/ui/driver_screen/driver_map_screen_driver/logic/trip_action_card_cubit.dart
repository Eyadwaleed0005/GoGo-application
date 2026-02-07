import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/const/const_things_of_admin.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/model/ride_model.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_ride_repository.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_trip_in_history_repository.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';
part 'trip_action_card_state.dart';

class TripActionCardCubit extends Cubit<TripActionCardState> {
  final DriverRideRepository _repo;
  Timer? _timer;
  final DriverTripSaveHistory historyRepo;
  TripActionCardCubit(this._repo, this.historyRepo)
    : super(TripActionCardInitial());

  Future<void> startTracking({
    required double toLat,
    required double toLng,
    required String userPhone,
    bool isDestination = false,
  }) async {
    emit(TripActionCardLoading());

    try {
      final position = await Geolocator.getCurrentPosition();
      final ride = await _repo.getRoute(
        fromLat: position.latitude,
        fromLng: position.longitude,
        toLat: toLat,
        toLng: toLng,
        userPhone: userPhone,
      );
      emit(TripActionCardUpdated(ride: ride, isDestination: isDestination));
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
        try {
          final pos = await Geolocator.getCurrentPosition();
          final updatedRide = await _repo.getRoute(
            fromLat: pos.latitude,
            fromLng: pos.longitude,
            toLat: toLat,
            toLng: toLng,
            userPhone: userPhone,
          );

          emit(
            TripActionCardUpdated(
              ride: updatedRide,
              isDestination: isDestination,
            ),
          );
        } catch (e) {
          emit(
            TripActionCardError(
              message: e.toString(),
              isDestination: isDestination,
            ),
          );
        }
      });
    } catch (e) {
      emit(
        TripActionCardError(
          message: e.toString(),
          isDestination: isDestination,
        ),
      );
    }
  }

  void stopTracking() {
    _timer?.cancel();
    emit(TripActionCardInitial());
  }

  Future<void> makePhoneCall(String phone) async {
    String normalizedPhone = phone.replaceFirst("+2", "").trim();

    final Uri phoneUri = Uri.parse(EndPoints.telUrl(normalizedPhone));

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
      emit(TripActionCardCall(normalizedPhone));
    } else {
      emit(
        TripActionCardError(
          message: "cannot_open_dialer".tr(),
          isDestination: false,
        ),
      );
    }
  }

  Future<void> openWhatsAppChat(String phone) async {
    final String message = ConstThingsOfUser.defaultWhatsAppMessage;
    String normalizedPhone = phone.replaceAll("+", "").trim();
    final Uri webUri = Uri.parse(
      EndPoints.whatsappUrl(normalizedPhone, message),
    );

    try {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      emit(
        TripActionCardError(
          message: "cannot_open_whatsapp".tr(),
          isDestination: false,
        ),
      );
    }
  }

  Future<void> saveTripToHistory() async {
    emit(TripActionCardLoading());
    try {
      await historyRepo.addTripToHistory();
      emit(TripActionCardSuccess());
    } catch (e) {
      emit(TripActionCardError(message: e.toString(), isDestination: false));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
