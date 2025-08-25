class ProfileModel {
  final String status;
  final String message;
  final User data;

  ProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json['status'],
      message: json['message'],
      data: User.fromJson(json['data']),
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

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String? phone;
  final String? gender;
  final String? image;
  final int? age;
  final String? occupation;
  final String? nameOfSpouse;
  final int? ageOfSpouse;
  final String? phoneNumberOfSpouse;
  final String? marriageDuration;
  final bool? firstTimeUser;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.phone,
    this.gender,
    this.image,
    this.age,
    this.occupation,
    this.nameOfSpouse,
    this.ageOfSpouse,
    this.phoneNumberOfSpouse,
    this.marriageDuration,
    this.firstTimeUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // int
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      gender: json['gender'],
      image: json['image'],
      age: json['age'] ?? 0,
      occupation: json['occupation'],
      nameOfSpouse: json['nameOfSpouse'],
      ageOfSpouse: json['ageOfSpouse'] ?? 0,
      phoneNumberOfSpouse: json['phoneNumberOfSpouse'],
      marriageDuration: json['marriageDuration'],
      firstTimeUser: json['firstTimeUser'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
      'image': image,
      'age': age,
      'occupation': occupation,
      'nameOfSpouse': nameOfSpouse,
      'ageOfSpouse': ageOfSpouse,
      'phoneNumberOfSpouse': phoneNumberOfSpouse,
      'marriageDuration': marriageDuration,
      'firstTimeUser': firstTimeUser,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

