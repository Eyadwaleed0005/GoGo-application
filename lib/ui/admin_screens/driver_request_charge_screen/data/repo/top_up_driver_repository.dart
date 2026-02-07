import 'package:dio/dio.dart';
import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_error_handler.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/data/model/top_up_action_model.dart';
import 'package:gogo/ui/admin_screens/driver_request_charge_screen/data/model/top_up_driver_model.dart';

class TopUpRepository {
  Future<List<TopUpDriver>> getTopUpRequests() async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.getDriverCharges,
      );

      final List<dynamic> values = response.data['\$values'];
      return values.map((e) => TopUpDriver.fromJson(e)).toList();
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> sendTopUpAction({
    required int chargeId, 
    required String action,
    required int value,
  }) async {
    try {
      final topUpAction = TopUpAction(
        action: action,
        value: value,
      );

      await DioHelper.postData(
        url: EndPoints.sendDriverAction(chargeId), 
        data: topUpAction.toJson(),
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
