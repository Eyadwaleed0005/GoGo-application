class ErrorModel {
  final String? id;
  final int? statusCode;
  final String? message;
  final List<String>? errors; 

  ErrorModel({
    this.id,
    this.statusCode,
    this.message,
    this.errors,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    List<String>? extractedErrors;

    if (json.containsKey("erorrs") && json["erorrs"] is Map<String, dynamic>) {
      final errorsMap = json["erorrs"] as Map<String, dynamic>;
      if (errorsMap.containsKey("\$values") && errorsMap["\$values"] is List) {
        extractedErrors = List<String>.from(errorsMap["\$values"]);
      }
    }

    return ErrorModel(
      id: json['\$id']?.toString(),
      statusCode: json['statusCode'] is int ? json['statusCode'] : null,
      message: json['message']?.toString(),
      errors: extractedErrors,
    );
  }

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return errors!.join("\n");
    }
    return message ?? "حدث خطأ غير معروف";
  }
}
