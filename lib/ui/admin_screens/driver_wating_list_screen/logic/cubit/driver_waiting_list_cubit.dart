import 'package:bloc/bloc.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/data/model/driver_watinig_list_model.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/data/repo/driver_waiting_list_repository.dart';
import 'package:meta/meta.dart';
part 'driver_waiting_list_state.dart';

class DriverWaitingListCubit extends Cubit<DriverWaitingListState> {
  final DriverWaitingListRepository repository;

  DriverWaitingListCubit(this.repository) : super(DriverWaitingListInitial());

  Future<void> fetchDriverWaitingList() async {
    emit(DriverWaitingListLoading());
    try {
      final result = await repository.getDriverWaitingList();
      emit(DriverWaitingListLoaded(result.drivers));
    } catch (e) {
      emit(DriverWaitingListError(e.toString()));
    }
  }
}
