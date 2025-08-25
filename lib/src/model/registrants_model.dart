class RegistrantsModel {
  final String status;
  final String message;
  final List<Registrant> data;

  RegistrantsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegistrantsModel.fromJson(Map<String, dynamic> json) {
    return RegistrantsModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => Registrant.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((registrant) => registrant.toJson()).toList(),
    };
  }
}

class Registrant {
  final int id;
  final int userId;
  final int eventId;
  final String qrcode;
  final bool attendingWithSpouse;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Registrant({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.qrcode,
    required this.attendingWithSpouse,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Registrant.fromJson(Map<String, dynamic> json) {
    return Registrant(
      id: json['id'] as int,
      userId: json['userId'] as int,
      eventId: json['eventId'] as int,
      qrcode: json['qrcode'] as String,
      attendingWithSpouse: json['attendingWithSpouse'] as bool,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'qrcode': qrcode,
      'attendingWithSpouse': attendingWithSpouse,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
