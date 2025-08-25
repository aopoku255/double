class PersonalQuestion {
  final int id;
  final int userId;
  final String question;
  final bool isUser;
  final bool isPublic; // 👈 added
  final DateTime createdAt;
  final DateTime updatedAt;

  PersonalQuestion({
    required this.id,
    required this.userId,
    required this.question,
    required this.isUser,
    required this.isPublic, // 👈 added
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create object from JSON
  factory PersonalQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalQuestion(
      id: json['id'] as int,
      userId: json['userId'] as int,
      question: json['question'] as String,
      isUser: json['isUser'] as bool,
      isPublic: json['isPublic'] as bool? ??
          false, // 👈 default false if backend doesn't send it
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'question': question,
      'isUser': isUser,
      'isPublic': isPublic, // 👈 added
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper for list parsing
  static List<PersonalQuestion> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PersonalQuestion.fromJson(json)).toList();
  }
}
