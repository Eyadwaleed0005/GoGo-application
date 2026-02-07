class OtpVerifyModel {
  final String phoneNumber;
  final String otp;

  OtpVerifyModel({required this.phoneNumber, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otp': otp,
    };
  }
}
