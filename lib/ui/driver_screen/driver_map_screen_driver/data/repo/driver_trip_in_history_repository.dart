import 'package:gogo/core/api/end_points.dart';
import 'package:gogo/core/dio_helper/dio_helper.dart';
import 'package:gogo/core/helper/driver_save_trip_helper_trips.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/model/driver_save_trip_model.dart';

class DriverTripSaveHistory {
  Future<void> addTripToHistory() async {
    final tripData = await SharedPreferencesHelperTrips.getTripData();
    final driverIdString = await SecureStorageHelper.getdata(
      key: SecureStorageKeys.driverId,
    );

    if (tripData == null || driverIdString == null) {
      throw Exception("Trip data or DriverId not found");
    }

    final double price = tripData['price'] as double;

    final fromPlace = tripData['fromPlace'] ?? "Unknown From";
    final toPlace = tripData['toPlace'] ?? "Unknown To";

    final history = DriverSaveTripModel(
      review: 5,
      paymentWay: "cash",
      from: fromPlace,
      to: toPlace,
      date: DateTime.now().toUtc(),
      totalTip: price,
      driverId: int.parse(driverIdString),
    );

    await DioHelper.postData(
      url: EndPoints.addDriverHistory,
      data: history.toJson(),
    );
  }
}
