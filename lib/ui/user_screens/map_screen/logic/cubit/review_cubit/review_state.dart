part of 'review_cubit.dart';

abstract class ReviewState {}

/// 🔹 حالات الريفيو
class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}

/// 🔹 حالات السواق
class DriverInfoLoading extends ReviewState {}

class DriverInfoLoaded extends ReviewState {
  final DriverInfo driver;
  DriverInfoLoaded(this.driver);
}

class DriverInfoError extends ReviewState {
  final String message;
  DriverInfoError(this.message);
}

/// 🔹 حالات حفظ الهيستوري
class HistorySaving extends ReviewState {}

class HistorySaved extends ReviewState {}

class HistoryError extends ReviewState {
  final String message;
  HistoryError(this.message);
}
