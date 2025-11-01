import 'package:bloc/bloc.dart';
import 'package:gogo/ui/admin_screens/admin_driver_info_screen/data/repo/driver_info_screen_repo.dart';
import 'package:meta/meta.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/model/driver_history_model.dart';

part 'admin_driver_info_screen_state.dart';

class AdminDriverInfoScreenCubit extends Cubit<AdminDriverInfoScreenState> {
  final DriverInfoRepo _repo;

  AdminDriverInfoScreenCubit(this._repo) : super(AdminDriverInfoScreenInitial());

  Future<void> loadDriverInfo(String userId) async {
    emit(AdminDriverInfoScreenLoading());

    final driverResult = await _repo.getDriverByUserId(userId);
    final historyResult = await _repo.getDriverHistory(userId);

    driverResult.fold(
      (failure) => emit(AdminDriverInfoScreenError(failure)),
      (driver) {
        historyResult.fold(
          (failure) => emit(AdminDriverInfoScreenError(failure)),
          (history) => emit(AdminDriverInfoScreenLoaded(driver, history)),
        );
      },
    );
  }
}
