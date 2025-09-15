class DriverModel {
  final int id;
  final String driverPhoto;
  final String driverIdCard;
  final String driverLicenseFront;
  final String driverLicenseBack;
  final String idCardFront;
  final String idCardBack;
  final String driverFullname;
  final String nationalId;
  final int age;
  final String licenseNumber;
  final String email;
  final String password;
  final DateTime licenseExpiryDate;
  final String userId;
  final String status;
  final double review; // ✅ خليه double
  final int wallet;

  DriverModel({
    required this.id,
    required this.driverPhoto,
    required this.driverIdCard,
    required this.driverLicenseFront,
    required this.driverLicenseBack,
    required this.idCardFront,
    required this.idCardBack,
    required this.driverFullname,
    required this.nationalId,
    required this.age,
    required this.licenseNumber,
    required this.email,
    required this.password,
    required this.licenseExpiryDate,
    required this.userId,
    required this.status,
    required this.review,
    required this.wallet,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? 0,
      driverPhoto: json['driverPhoto'] ?? '',
      driverIdCard: json['driverIdCard'] ?? '',
      driverLicenseFront: json['driverLicenseFront'] ?? '',
      driverLicenseBack: json['driverLicenseBack'] ?? '',
      idCardFront: json['idCardFront'] ?? '',
      idCardBack: json['idCardBack'] ?? '',
      driverFullname: json['driverFullname'] ?? '',
      nationalId: json['nationalId'] ?? '',
      age: json['age'] ?? 0,
      licenseNumber: json['licenseNumber'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      licenseExpiryDate:
          DateTime.tryParse(json['licenseExpiryDate'] ?? '') ?? DateTime.now(),
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      review: (json['review'] is int)
          ? (json['review'] as int).toDouble()
          : (json['review'] ?? 0.0).toDouble(), // ✅ نحوله Double
      wallet: json['wallet'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverPhoto': driverPhoto,
      'driverIdCard': driverIdCard,
      'driverLicenseFront': driverLicenseFront,
      'driverLicenseBack': driverLicenseBack,
      'idCardFront': idCardFront,
      'idCardBack': idCardBack,
      'driverFullname': driverFullname,
      'nationalId': nationalId,
      'age': age,
      'licenseNumber': licenseNumber,
      'email': email,
      'password': password,
      'licenseExpiryDate': licenseExpiryDate.toIso8601String(),
      'userId': userId,
      'status': status,
      'review': review, 
      'wallet': wallet,
    };
  }
}
