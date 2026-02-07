part of 'ride_request_screen_cubit.dart';

enum RideRequestStatus { initial, loading, success, error }

@immutable
class RideRequestScreenState {
  final String tripType;
  final String passengers;
  final String price;
  final String notes;
  final double distanceKm;
  final int suggestedPrice;
  final String paymentWay;
  final String carType;   // ✅ جديد
  final bool pinkMode;    // ✅ جديد

  final RideRequestStatus status;
  final String? errorMessage;
  final GetAllOrdersModel? createdOrder;

  const RideRequestScreenState({
    required this.tripType,
    required this.passengers,
    required this.price,
    required this.notes,
    required this.distanceKm,
    required this.suggestedPrice,
    required this.paymentWay,
    required this.carType,   // ✅
    required this.pinkMode,  // ✅
    required this.status,
    this.errorMessage,
    this.createdOrder,
  });

  RideRequestScreenState copyWith({
    String? tripType,
    String? passengers,
    String? price,
    String? notes,
    double? distanceKm,
    int? suggestedPrice,
    String? paymentWay,
    String? carType,   
    bool? pinkMode,    
    RideRequestStatus? status,
    String? errorMessage,
    GetAllOrdersModel? createdOrder,
  }) {
    return RideRequestScreenState(
      tripType: tripType ?? this.tripType,
      passengers: passengers ?? this.passengers,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      distanceKm: distanceKm ?? this.distanceKm,
      suggestedPrice: suggestedPrice ?? this.suggestedPrice,
      paymentWay: paymentWay ?? this.paymentWay,
      carType: carType ?? this.carType,   
      pinkMode: pinkMode ?? this.pinkMode, 
      status: status ?? this.status,
      errorMessage: errorMessage,
      createdOrder: createdOrder,
    );
  }
}
