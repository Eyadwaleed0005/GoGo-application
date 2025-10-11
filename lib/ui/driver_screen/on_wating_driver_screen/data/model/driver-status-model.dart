class DriverStatusModel {
  final int id;
  final String status;
  final String carBrand; 
  final String gender;

  DriverStatusModel({
    required this.id,
    required this.status,
    required this.carBrand, 
    required this.gender,
  });

  factory DriverStatusModel.fromJson(Map<String, dynamic> json) {
    return DriverStatusModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      carBrand: json['carBrand'] ?? '', 
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'carBrand': carBrand, 
      'gender': gender,
    };
  }
}
