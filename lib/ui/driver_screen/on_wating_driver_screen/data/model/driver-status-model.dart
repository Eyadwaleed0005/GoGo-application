class DriverStatusModel {
  final int id;
  final String status;

  DriverStatusModel({
    required this.id,
    required this.status,
  });

  factory DriverStatusModel.fromJson(Map<String, dynamic> json) {
    return DriverStatusModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
    };
  }
}
