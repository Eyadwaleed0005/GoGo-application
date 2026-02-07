import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/data/model/driver_watinig_list_model.dart';

class DriverWaitingListRepository {
  Future<DriverWaitingListResponse> getDriverWaitingList() async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getDriverWaitingList,
      );
      return DriverWaitingListResponse.fromJson(response.data);
    } on DioException catch (e) {
      final message = DioExceptionHandler.handleDioError(e);
      throw message; 
    } catch (e) {
      throw e.toString().replaceFirst('Exception: ', '');
    }
  }
}
