part of 'driver_wallet_screen_cubit.dart';

@immutable
class DriverWalletScreenState {
  final int wallet;
  final List<XFile?> images;
  final bool isLoading;
  final String? error;
  final DriverPayModel? driverPay;
  final bool showSuccessAnimation;

  const DriverWalletScreenState({
    required this.wallet,
    required this.images,
    this.isLoading = false,
    this.error,
    this.driverPay,
    this.showSuccessAnimation = false,
  });

  DriverWalletScreenState copyWith({
    int? wallet,
    List<XFile?>? images,
    bool? isLoading,
    Object? error = _noChange, 
    DriverPayModel? driverPay,
    bool? showSuccessAnimation,
  }) {
    return DriverWalletScreenState(
      wallet: wallet ?? this.wallet,
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
      error: error == _noChange ? this.error : error as String?, 
      driverPay: driverPay ?? this.driverPay,
      showSuccessAnimation: showSuccessAnimation ?? this.showSuccessAnimation,
    );
  }
}

const _noChange = Object();
