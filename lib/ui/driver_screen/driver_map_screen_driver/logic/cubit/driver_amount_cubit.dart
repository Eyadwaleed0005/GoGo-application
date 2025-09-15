import 'package:bloc/bloc.dart';
import 'package:gogo/core/const/const_things_of_admin.dart';
import 'package:gogo/core/helper/driver_daily_amount-helper.dart';
import 'package:meta/meta.dart';
import 'package:gogo/core/helper/driver_save_trip_helper_trips.dart';
import 'package:gogo/ui/driver_screen/driver_map_screen_driver/data/repo/driver_amount_repository.dart';

part 'driver_amount_state.dart';

class DriverAmountCubit extends Cubit<DriverAmountState> {
  final DriverAmountRepository repository;

  DriverAmountCubit({required this.repository}) : super(DriverAmountInitial());

  Future<void> deductTripAmount() async {
    emit(DriverAmountLoading());

    try {
      final tripData = await SharedPreferencesHelperTrips.getTripData();
      final price = double.parse(tripData!['price'].toString());

      final developerProfit =
          (price * ConstThingsOfUser.percentageOfProfit).toInt();
      final driverShare = price.toInt() - developerProfit;

      await repository.deductAmount(developerProfit);

      await DriverDailyAmountHelper.addToDailyAmount(driverShare);

      emit(DriverAmountSuccess(developerProfit));
    } catch (e) {
      emit(DriverAmountError(e.toString()));
    }
  }
}
