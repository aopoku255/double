import 'dart:convert';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:http/http.dart' as http;
import '../model/profile_model.dart';

class ProfileService {
  Future<ProfileModel?> getUserProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/userinfo/$userId'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer yourToken', // if needed
        },
      );



      if (response.statusCode == 200 || response.statusCode ==201) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        print(jsonResponse);
        return ProfileModel.fromJson(jsonResponse);
      } else {
        print('Failed to load profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }
}
