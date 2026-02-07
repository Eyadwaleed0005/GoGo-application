import 'package:bloc/bloc.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/model/driver_history_model.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/repo/driver_history_repository.dart';
import 'package:meta/meta.dart';
part 'driver_history_screen_state.dart';

class DriverHistoryScreenCubit extends Cubit<DriverHistoryScreenState> {
  final DriverHistoryRepository repository;

  DriverHistoryScreenCubit(this.repository)
      : super(DriverHistoryScreenInitial());

  Future<void> fetchDriverHistory() async {
    if (isClosed) return; 
    emit(DriverHistoryScreenLoading());

    try {
      final historyList = await repository.getDriverHistory();
      if (isClosed) return;
      emit(DriverHistoryScreenLoaded(historyList));
    } catch (e) {
      if (isClosed) return;
      emit(DriverHistoryScreenError(e.toString()));
    }
  }
}

