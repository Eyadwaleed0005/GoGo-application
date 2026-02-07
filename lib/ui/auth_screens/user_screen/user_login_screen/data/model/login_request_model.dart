class LoginRequestModel {
  final String emailOrPhone;
  final String password;

  LoginRequestModel({
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
