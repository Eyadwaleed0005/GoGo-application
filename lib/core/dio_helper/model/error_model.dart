class ErrorModel {
  final String? id;
  final int? statusCode;
  final String? message;

  ErrorModel({
    this.id,
    this.statusCode,
    this.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      id: json['\$id']?.toString(),
      statusCode: json['statusCode'] is int ? json['statusCode'] : null,
      message: json['message']?.toString(),
    );
  }

  @override
  String toString() {
    return message ?? "حدث خطأ غير معروف";
  }
}
