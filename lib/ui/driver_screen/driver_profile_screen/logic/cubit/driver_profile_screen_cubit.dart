import 'package:bloc/bloc.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/model/driver_profile_model.dart';
import 'package:gogo/ui/driver_screen/driver_profile_screen/data/repo/repo_driver_profile_screen.dart';
import 'package:meta/meta.dart';

part 'driver_profile_screen_state.dart';

class DriverProfileScreenCubit extends Cubit<DriverProfileScreenState> {
  final DriverRepository repository;

  DriverProfileScreenCubit(this.repository)
      : super(DriverProfileScreenInitial());

  DriverProfile? currentProfile;

  Future<void> fetchDriverProfile() async {
    emit(DriverProfileScreenLoading());

    final result = await repository.getDriverProfile();

    if (isClosed) return; 

    result.fold(
      (error) {
        if (isClosed) return; 
        emit(
          DriverProfileScreenLoaded(
            driverProfile: DriverProfile(
              driverPhoto: AppImage().defultProfileAccount,
              review: 0,
            ),
          ),
        );
      },
      (driverProfile) {
        if (isClosed) return; 
        currentProfile = driverProfile;
        emit(DriverProfileScreenLoaded(driverProfile: driverProfile));
      },
    );
  }
}
