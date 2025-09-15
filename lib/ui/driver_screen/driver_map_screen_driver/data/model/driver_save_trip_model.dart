class DriverSaveTripModel {
  final int review;
  final String paymentWay;
  final String from;
  final String to;
  final DateTime date;
  final num totalTip; // 👈 يقدر يبقى int أو double
  final int driverId;

  DriverSaveTripModel({
    required this.review,
    required this.paymentWay,
    required this.from,
    required this.to,
    required this.date,
    required this.totalTip,
    required this.driverId,
  });

  Map<String, dynamic> toJson() {
    return {
      "review": review,
      "paymentWay": paymentWay,
      "from": from,
      "to": to,
      "date": date.toUtc().toIso8601String(),
      "totalTip": totalTip, // هيبعت int لو مفيش كسور
      "driverId": driverId,
    };
  }
}
