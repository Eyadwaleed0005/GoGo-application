enum DriverApprovalStatus {
  pending,
  approved,
  reject,
}

class DriverStatusUpdateModel {
  final DriverApprovalStatus status;

  DriverStatusUpdateModel({
    this.status = DriverApprovalStatus.pending,
  });

  /// تحويل الـ JSON من السيرفر لموديل
  factory DriverStatusUpdateModel.fromJson(Map<String, dynamic> json) {
    return DriverStatusUpdateModel(
      status: _statusFromString(json['status']),
    );
  }

  /// البودي اللي هيتبعت في الريكويست
  Map<String, dynamic> toJson() {
    return {
      'status': status.name, // ✅ بس الحالة
    };
  }

  DriverStatusUpdateModel copyWith({
    DriverApprovalStatus? status,
  }) {
    return DriverStatusUpdateModel(
      status: status ?? this.status,
    );
  }

  /// Helper لتحويل String لـ Enum
  static DriverApprovalStatus _statusFromString(String? value) {
    switch (value) {
      case 'approved':
        return DriverApprovalStatus.approved;
      case 'reject':
        return DriverApprovalStatus.reject;
      case 'pending':
        return DriverApprovalStatus.pending;
      default:
        return DriverApprovalStatus.pending;
    }
  }
}
