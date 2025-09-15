class DriverAmount {
  final int driverId;
  final int amount;

  DriverAmount({
    required this.driverId,
    required this.amount,
  });

  factory DriverAmount.fromJson(Map<String, dynamic> json) {
    return DriverAmount(
      driverId: json['driverId'] ?? 0,
      amount: json['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'amount': amount,
    };
  }

  DriverAmount copyWith({
    int? driverId,
    int? amount,
  }) {
    return DriverAmount(
      driverId: driverId ?? this.driverId,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() => 'DriverAmount(driverId: $driverId, amount: $amount)';
}
