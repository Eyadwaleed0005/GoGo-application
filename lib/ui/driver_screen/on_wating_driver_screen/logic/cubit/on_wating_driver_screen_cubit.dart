import 'package:bloc/bloc.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/model/driver-status-model.dart';
import 'package:gogo/ui/driver_screen/on_wating_driver_screen/data/repo/driver_status_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gogo/core/local/shared_preference_keys.dart';

part 'on_wating_driver_screen_state.dart';

class OnWatingDriverScreenCubit extends Cubit<OnWatingDriverScreenState> {
  final DriverStatusRepository driverStatusRepository;

  OnWatingDriverScreenCubit(this.driverStatusRepository)
      : super(OnWatingDriverScreenInitial());

  Future<void> fetchDriverStatus() async {
    emit(OnWatingDriverScreenLoading());
    try {
      final DriverStatusModel status =
          await driverStatusRepository.getDriverStatus();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        SharedPreferenceKeys.statusOfAccountDriver,
        status.status,
      );

      print("✅ Driver status fetched and saved:");
      print("statusOfAccountDriver => ${status.status}");

      emit(OnWatingDriverScreenSuccess(status: status));
    } catch (e) {
      print("❌ Error fetching driver status: $e");
      emit(OnWatingDriverScreenFailure(errorMessage: e.toString()));
    }
  }
}
