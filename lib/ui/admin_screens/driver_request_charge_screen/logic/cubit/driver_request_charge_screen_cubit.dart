import 'package:bloc/bloc.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/data/repo/top_up_driver_repository.dart';
import 'package:meta/meta.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/data/model/top_up_driver_model.dart';

part 'driver_request_charge_screen_state.dart';

class DriverRequestChargeScreenCubit extends Cubit<DriverRequestChargeScreenState> {
  final TopUpRepository repository;

  DriverRequestChargeScreenCubit(this.repository) : super(DriverRequestChargeScreenInitial());

  Future<void> fetchTopUpRequests() async {
    emit(DriverRequestChargeLoading());
    try {
      final requests = await repository.getTopUpRequests();
      emit(DriverRequestChargeLoaded(requests));
    } catch (e) {
      emit(DriverRequestChargeError(e.toString()));
    }
  }

Future<void> sendAction({
  required int chargeId,  
  required String action,
  required int value,
}) async {
  emit(DriverRequestChargeActionLoading());
  try {
    await repository.sendTopUpAction(
      chargeId: chargeId,
      action: action,
      value: value,
    );
    emit(DriverRequestChargeActionSuccess());

    await fetchTopUpRequests();
  } catch (e) {
    emit(DriverRequestChargeActionError(e.toString()));
  }
}

}
