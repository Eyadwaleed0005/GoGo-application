import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/services/suggested_price_calculator.dart';
import 'package:meta/meta.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';
import 'package:gogo/ui/user_screens/request_screen/data/repo/orders_repository.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';

part 'ride_request_screen_state.dart';

class RideRequestScreenCubit extends Cubit<RideRequestScreenState> {
  final OrdersRepository _ordersRepository = OrdersRepository();

  RideRequestScreenCubit(double distanceKm)
      : super(RideRequestScreenState(
          tripType: "one_of_group",
          passengers: "1",
          price: "",
          notes: "",
          distanceKm: distanceKm,
          suggestedPrice: SuggestedPriceCalculator.calculate(
            tripType: "one_of_group",
            distanceKm: distanceKm,
          ),
          paymentWay: "cash", // 🔥 القيمة الافتراضية
          status: RideRequestStatus.initial,
        ));

  void changeTripType(String value) {
    final passengers = value == "delivery"
        ? "0"
        : (state.passengers == "0" ? "" : state.passengers);

    final newSuggestedPrice = SuggestedPriceCalculator.calculate(
      tripType: value,
      distanceKm: state.distanceKm,
    );

    emit(state.copyWith(
      tripType: value,
      passengers: passengers,
      suggestedPrice: newSuggestedPrice,
    ));
  }

  void changePassengers(String value) {
    emit(state.copyWith(passengers: value));
  }

  void changePrice(String value) {
    emit(state.copyWith(price: value));
  }

  void changeNotes(String value) {
    emit(state.copyWith(notes: value));
  }

  void changePaymentWay(String value) {
    emit(state.copyWith(paymentWay: value));
  }

  bool validateInputs() {
    if (state.tripType == "delivery") {
      if (state.passengers != "0") return false;
    } else {
      if (state.passengers.isEmpty || state.passengers == "0") return false;
    }

    if (state.price.isEmpty) return false;

    final priceValue = int.tryParse(state.price) ?? 0;
    if (priceValue < state.suggestedPrice) return false;

    return true;
  }

  Future<void> createOrder({
    required String from,
    required String to,
    required LatLngModel fromLatLng,
    required LatLngModel toLatLng,
  }) async {
    if (!validateInputs()) {
      emit(state.copyWith(
        status: RideRequestStatus.error,
        errorMessage: "invalid_inputs".tr(),
      ));
      return;
    }

    emit(state.copyWith(status: RideRequestStatus.loading));
    try {
      final userId = await SecureStorageHelper.getdata(
        key: SecureStorageKeys.userId,
      );

      final order = GetAllOrdersModel(
        id: 0,
        userId: userId!,
        userPhone: "",
        userName: "",
        userImage: "",
        date: DateTime.now(),
        from: from,
        to: to,
        fromLatLng: fromLatLng,
        toLatLng: toLatLng,
        expectedPrice: double.tryParse(state.price) ?? 0.0,
        type: state.tripType,
        distance: state.distanceKm,
        notes: state.notes,
        noPassengers: int.tryParse(state.passengers) ?? 1,
        status: 'pending',
        driverId: null,
        review: 0,
        paymentWay: state.paymentWay, 
      );

      final createdOrder = await _ordersRepository.createOrderWithFCM(order);

      emit(state.copyWith(
        status: RideRequestStatus.success,
        createdOrder: createdOrder,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RideRequestStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
