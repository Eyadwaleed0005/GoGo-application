import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gogo/core/helper/driver_save_trip_helper_trips.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:meta/meta.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/model/driver-status-model.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/repo/driver_status_repository.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit(this.driverStatusRepository) : super(SplashScreenInitial());

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final DriverStatusRepository driverStatusRepository;

  Future<void> checkAuth() async {
    emit(SplashScreenLoading());

    final token = await _storage.read(key: SecureStorageKeys.token);
    final userType = await _storage.read(key: SecureStorageKeys.userType);
    final userId = await _storage.read(key: SecureStorageKeys.userId);

    await Future.delayed(const Duration(seconds: 2));

    if (token != null && token.isNotEmpty && userId != null && userId.isNotEmpty) {
      if (userType == 'driver') {
        try {
          final DriverStatusModel driverStatus =
              await driverStatusRepository.getDriverStatus();

          final isComplete = await SharedPreferencesHelper.getBool(
            key: SharedPreferenceKeys.driverCompleteRegister,
          );

          if (isComplete == true && driverStatus.status == 'approved') {
            await recoverTripState(); 
          } else if (isComplete == true && driverStatus.status == 'pending') {
            emit(SplashScreenDriverPending());
          } else if (isComplete == true && driverStatus.status == 'reject') {
            emit(SplashScreenDriverRejected());
          } else {
            emit(SplashScreenUnAuthenticated());
          }
        } catch (_) {
          final savedStatus = await SharedPreferencesHelper.getString(
            key: SharedPreferenceKeys.statusOfAccountDriver,
          );
          final isComplete = await SharedPreferencesHelper.getBool(
            key: SharedPreferenceKeys.driverCompleteRegister,
          );
          if (isComplete == true && savedStatus == 'approved') {
            await recoverTripState();
          } else if (isComplete == true && savedStatus == 'pending') {
            emit(SplashScreenDriverPending());
          } else if (isComplete == true && savedStatus == 'reject') {
            emit(SplashScreenDriverRejected());
          } else {
            emit(SplashScreenUnAuthenticated());
          }
        }
      } else if (userType == 'passenger') {
        emit(SplashScreenPassenger());
      } else {
        emit(SplashScreenUnAuthenticated());
      }
    } else {
      emit(SplashScreenUnAuthenticatedToLanguage());
    }
  }

  Future<void> recoverTripState() async {
    final tripData = await SharedPreferencesHelperTrips.getTripData();

    if (tripData != null) {
      final isOnTrip = tripData['isOnTrip'] as bool? ?? false;
      final isOnTripTwo = tripData['isOnTripTwo'] as bool? ?? false;
      if (isOnTripTwo) {
        emit(SplashScreenDriverEndTrip()); 
      } else if (isOnTrip) {
        emit(SplashScreenDriverStartTrip()); 
      } else {
        emit(SplashScreenDriverApproved()); 
      }
    } else {
      emit(SplashScreenDriverApproved());
    }
  }
}
