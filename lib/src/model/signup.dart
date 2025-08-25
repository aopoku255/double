class SignupResponseModel {
  final String status;
  final String message;
  final UserOtpData data;

  SignupResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      status: json['status'],
      message: json['message'],
      data: UserOtpData.fromJson(json['data']),
    );
  }
}

class UserOtpData {
  final int id;
  final int userId;
  final String code;
  final bool verified;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserOtpData({
    required this.id,
    required this.userId,
    required this.code,
    required this.verified,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserOtpData.fromJson(Map<String, dynamic> json) {
    return UserOtpData(
      id: json['id'],
      userId: json['userId'],
      code: json['code'],
      verified: json['verified'],
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
