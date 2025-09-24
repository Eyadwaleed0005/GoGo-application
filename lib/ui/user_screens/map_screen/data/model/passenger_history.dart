class PassengerHistory {
  final String userId;
  final String from;
  final String to;
  final double price;
  final DateTime date;
  final String paymentMethod;
  final String rideType;

  PassengerHistory({
    required this.userId,
    required this.from,
    required this.to,
    required this.price,
    required this.date,
    required this.paymentMethod,
    required this.rideType,
  });

  factory PassengerHistory.fromJson(Map<String, dynamic> json) {
    return PassengerHistory(
      userId: json['userId'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      price: (json['price'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      paymentMethod: json['paymentMethod'] as String,
      rideType: json['rideType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'from': from,
      'to': to,
      'price': price,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'rideType': rideType,
    };
  }
}
