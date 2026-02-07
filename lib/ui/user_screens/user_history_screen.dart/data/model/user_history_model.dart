class UserHistory {
  final int id;
  final String userId;
  final String from;
  final String to;
  final double price;
  final DateTime date;
  final String paymentMethod;
  final String rideType;

  UserHistory({
    this.id = 0,
    this.userId = "",
    this.from = "",
    this.to = "",
    this.price = 0.0,
    DateTime? date,
    this.paymentMethod = "cash",
    this.rideType = "standard",
  }) : date = date ?? DateTime.now();

  factory UserHistory.fromJson(Map<String, dynamic> json) {
    return UserHistory(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? "",
      from: json['from'] ?? "",
      to: json['to'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      date: json['date'] != null
          ? DateTime.tryParse(json['date']) ?? DateTime.now()
          : DateTime.now(),
      paymentMethod: json['paymentMethod'] ?? "cash",
      rideType: json['rideType'] ?? "standard",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "from": from,
      "to": to,
      "price": price,
      "date": date.toIso8601String(),
      "paymentMethod": paymentMethod,
      "rideType": rideType,
    };
  }
}
