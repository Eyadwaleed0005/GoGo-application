class RegisterRequestModel {
  final String email;
  final String fullName;
  final String phoneNumber;
  final String password;
  final String userType;
  final String gender;

  RegisterRequestModel({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.userType,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'password': password,
      'userType': userType,
      'gender': gender,
    };
  }
}
