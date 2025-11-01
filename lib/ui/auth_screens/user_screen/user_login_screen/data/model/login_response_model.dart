class LoginResponseModel {
  final String userId;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String token;
  final String userType;
  final String gender;

  LoginResponseModel({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.token,
    required this.userType,
    required this.gender,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      userId: json["userId"] ?? '',
      displayName: json["dispalyName"] ?? '', 
      email: json["email"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      token: json["token"] ?? '',
      userType: json["userType"] ?? '',
      gender: json["gender"] ?? '',
    );
  }
}
