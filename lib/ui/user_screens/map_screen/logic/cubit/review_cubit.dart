import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_info.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/driver_info_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/driver_review_service.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/user_order_repository.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final UserOrderRepository _orderRepository;

  ReviewCubit(this._orderRepository) : super(ReviewInitial());

  /// 🔹 إرسال الريفيو + حفظ الرحلة في الهيستوري
  Future<void> sendReviewAndSaveHistory(int review) async {
    emit(ReviewLoading());
    try {
      final result = await DriverReviewService.submitReview(review: review);

      if (result.success) {
        emit(HistorySaving());
        await _orderRepository.saveCurrentOrderAsHistory();
        emit(HistorySaved());
        emit(ReviewSuccess());
      } else {
        emit(ReviewError(result.message ?? "Unknown error"));
      }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  /// 🔹 جلب بيانات السائق
  Future<void> fetchDriverInfo() async {
    emit(DriverInfoLoading());
    try {
      final driver = await DriverRepository.fetchDriverInfo();

      if (driver != null) {
        emit(DriverInfoLoaded(driver));
      } else {
        emit(DriverInfoError("لم يتم العثور على بيانات السائق من السيرفر"));
      }
    } catch (e) {
      emit(DriverInfoError(e.toString()));
    }
  }
}
