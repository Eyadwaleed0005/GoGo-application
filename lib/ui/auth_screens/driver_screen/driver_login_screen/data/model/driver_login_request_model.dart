class DriverLoginRequestModel {
  final String emailOrPhone;
  final String password;

  DriverLoginRequestModel({
    required this.emailOrPhone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "emailOrPhone": emailOrPhone,
      "password": password,
    };
  }
}
