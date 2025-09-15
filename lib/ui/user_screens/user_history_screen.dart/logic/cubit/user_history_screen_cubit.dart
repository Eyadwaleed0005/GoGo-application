import 'package:bloc/bloc.dart';
import 'package:gogo/ui/user_screens/user_history_screen.dart/data/model/user_history_model.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import '../../data/repo/user_history_repository.dart';

part 'user_history_screen_state.dart';

class UserHistoryScreenCubit extends Cubit<UserHistoryScreenState> {
  final UserHistoryRepository repository;

  UserHistoryScreenCubit(this.repository) : super(UserHistoryScreenInitial());

  Future<void> fetchUserHistory() async {
    emit(UserHistoryScreenLoading());
    try {
      final history = await repository.getUserHistory();

      if (history.isEmpty) {
        emit(UserHistoryScreenEmpty());
      } else {
        emit(UserHistoryScreenSuccess(history));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        emit(UserHistoryScreenEmpty()); 
      } else {
        emit(UserHistoryScreenFailure(e.message ?? "error"));
      }
    } catch (e) {
      emit(UserHistoryScreenFailure(e.toString()));
    }
  }
}
