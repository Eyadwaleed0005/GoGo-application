class RegisterRequestModel {
  final String email;
  final String fullName;
  final String phoneNumber;
  final String password;
  final String userType;

  RegisterRequestModel({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'password': password,
      'userType': userType,
    };
  }
}
