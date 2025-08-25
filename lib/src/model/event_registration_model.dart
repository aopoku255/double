class RegistrationResponse {
  final String status;
  final String message;
  final RegistrationData data;

  RegistrationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: RegistrationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class RegistrationData {
  final String status;
  final int id;
  final int userId;
  final int eventId;
  final String qrcode;
  final bool attendingWithSpouse;
  final DateTime updatedAt;
  final DateTime createdAt;

  RegistrationData({
    required this.status,
    required this.id,
    required this.userId,
    required this.eventId,
    required this.qrcode,
    required this.attendingWithSpouse,
    required this.updatedAt,
    required this.createdAt,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      status: json['status'] as String,
      id: json['id'] as int,
      userId: json['userId'] as int,
      eventId: json['eventId'] as int,
      qrcode: json['qrcode'] as String,
      attendingWithSpouse: json['attendingWithSpouse'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'qrcode': qrcode,
      'attendingWithSpouse': attendingWithSpouse,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}