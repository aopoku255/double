import 'dart:convert';
import 'package:doubles/src/model/loginmodel.dart';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInService {
  Future<LoginResponse> signIn(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to sign in: ${response.body}');
    }
  }

  Future<LoginResponse> updateUser(Map<String, dynamic> updatedData) async {
    final pref  = await SharedPreferences.getInstance();
    final userId = await pref.getInt("userId");
    final url = Uri.parse('$baseUrl/auth/userinfo/${userId}');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

}
