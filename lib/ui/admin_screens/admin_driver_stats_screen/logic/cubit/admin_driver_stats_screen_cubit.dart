import 'package:bloc/bloc.dart';
import 'package:gogo/core/models/drivers_models/driver_model.dart';
import 'package:meta/meta.dart';
import 'package:gogo/ui/admin_screens/admin_driver_stats_screen/data/repo/driver_approved_repo.dart';

part 'admin_driver_stats_screen_state.dart';

class AdminDriverStatsScreenCubit extends Cubit<AdminDriverStatsScreenState> {
  final DriverApprovedRepo _repo;

  AdminDriverStatsScreenCubit(this._repo)
      : super(AdminDriverStatsScreenInitial());

  Future<void> getAllDrivers() async {
    emit(AdminDriverStatsScreenLoading());
    final result = await _repo.getAllDrivers();
    result.fold(
      (error) => emit(AdminDriverStatsScreenError(error)),
      (drivers) => emit(AdminDriverStatsScreenLoaded(drivers)),
    );
  }
}
