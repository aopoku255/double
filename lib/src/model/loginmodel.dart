class LoginResponse {
  final String status;
  final String message;
  final UserData data;
  final String token;

  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
    'token': token,
  };
}

class UserData {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phone;
  final String? gender;
  final String? image;
  final dynamic age;
  final String? occupation;
  final String? nameOfSpouse;
  final dynamic ageOfSpouse;
  final String? phoneNumberOfSpouse;
  final String? marriageDuration;
  final bool firstTimeUser;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phone,
    this.gender,
    this.image,
    this.age,
    this.occupation,
    this.nameOfSpouse,
    this.ageOfSpouse,
    this.phoneNumberOfSpouse,
    this.marriageDuration,
    required this.firstTimeUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'],
      gender: json['gender'],
      image: json['image'],
      age: json['age'],
      occupation: json['occupation'],
      nameOfSpouse: json['nameOfSpouse'],
      ageOfSpouse: json['ageOfSpouse'],
      phoneNumberOfSpouse: json['phoneNumberOfSpouse'],
      marriageDuration: json['marriageDuration'],
      firstTimeUser: json['firstTimeUser'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
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
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
