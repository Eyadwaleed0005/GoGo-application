
class DriverAuthModel {
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
  final String licenseExpiryDate;
  final String userId;

  DriverAuthModel({
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
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "driverPhoto": driverPhoto,
      "driverIdCard": driverIdCard,
      "driverLicenseFront": driverLicenseFront,
      "driverLicenseBack": driverLicenseBack,
      "idCardFront": idCardFront,
      "idCardBack": idCardBack,
      "driverFullname": driverFullname,
      "nationalId": nationalId,
      "age": age,
      "licenseNumber": licenseNumber,
      "email": email,
      "password": password,
      "licenseExpiryDate": licenseExpiryDate,
      "userId": userId,
    };
  }

  factory DriverAuthModel.fromJson(Map<String, dynamic> json) {
    return DriverAuthModel(
      id: json["id"],
      driverPhoto: json["driverPhoto"],
      driverIdCard: json["driverIdCard"],
      driverLicenseFront: json["driverLicenseFront"],
      driverLicenseBack: json["driverLicenseBack"],
      idCardFront: json["idCardFront"],
      idCardBack: json["idCardBack"],
      driverFullname: json["driverFullname"],
      nationalId: json["nationalId"],
      age: json["age"],
      licenseNumber: json["licenseNumber"],
      email: json["email"],
      password: json["password"],
      licenseExpiryDate: json["licenseExpiryDate"],
      userId: json["userId"],
    );
  }
}
