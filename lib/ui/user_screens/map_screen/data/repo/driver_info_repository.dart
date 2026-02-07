import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/driver_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverRepository {
  static Future<DriverInfo?> fetchDriverInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getInt(SharedPreferenceKeys.driverIdTrip);

      final response = await DioHelper.getData(
        url: EndPoints.getDriverById(driverId!),
      );

      if (response.data != null) {
        return DriverInfo.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
