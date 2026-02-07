import 'package:bloc/bloc.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';
import 'package:gogo/core/models/car_models/car_model.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/data/model/driver_status_update_model.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/data/repo/driver_car_repository.dart';
import 'package:gogo/ui/admin_screens/driver_check_data_screen/data/repo/driver_status_repository.dart';
import 'package:meta/meta.dart';

part 'check_data_driver_screen_state.dart';

class CheckDataDriverScreenCubit extends Cubit<CheckDataDriverScreenState> {
  final DriverCarRepository carRepository;
  final DriverStatusRepository statusRepository;

  CheckDataDriverScreenCubit(
    this.carRepository,
    this.statusRepository,
  ) : super(CheckDataDriverScreenInitial());

  Future<void> fetchDriverAndCar(int driverId, String userId) async {
    emit(CheckDataDriverScreenLoading());
    try {
      final (driver, car) = await carRepository.getDriverAndCar(
        driverId: driverId,
        userId: userId,
      );
      if (driver != null && car != null) {
        emit(CheckDataDriverScreenLoaded(driver, car));
      } else {
        emit(CheckDataDriverScreenError("Driver or Car not found"));
      }
    } catch (e) {
      emit(CheckDataDriverScreenError(e.toString()));
    }
  }

  Future<void> updateDriverStatus({
    required int driverId,
    required DriverApprovalStatus status,
  }) async {
    emit(DriverStatusUpdateLoading());
    try {
      final message = await statusRepository.updateDriverStatus(
        driverId: driverId,
        model: DriverStatusUpdateModel(status: status),
      );

      emit(DriverStatusUpdateSuccess(status, message));
    } catch (e) {
      emit(DriverStatusUpdateError(e.toString()));
    }
  }
}
