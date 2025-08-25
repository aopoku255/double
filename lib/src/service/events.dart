import 'dart:convert';
import 'package:doubles/src/model/event_registration_model.dart';
import 'package:doubles/src/model/events.dart';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:http/http.dart' as http;

import '../model/registrants_model.dart';

class EventService {
  final String upcomingUrl = '${baseUrl}/event/get-upcoming-events';
  final String pastUrls = '${baseUrl}/event/get-past-events';

  Future<List<Event>> getAllEvents() async {
    final response = await http.get(Uri.parse(upcomingUrl));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Extract 'data' key if the response is wrapped in status/message/data
      final List<dynamic> eventsJson = responseBody['data'];

      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
  Future<List<Event>> getPastEvents() async {
    final response = await http.get(Uri.parse(pastUrls));


    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Extract 'data' key if the response is wrapped in status/message/data
      final List<dynamic> eventsJson = responseBody['data'];

      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
  Future<List<Registrant>> getRegistrants(int userId, int eventId) async {
    final response = await http.get(Uri.parse('$baseUrl/event/get-registrants?userId=${userId}&eventId=${eventId}'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(response.body);
      if (responseBody['status'] == 'Success') {
        final registrantsModel = RegistrantsModel.fromJson(responseBody);
        return registrantsModel.data;
      } else {
        throw Exception(responseBody['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to load registrants. Status code: ${response.statusCode}');
    }
  }

  Future<RegistrationResponse> registerEvent({
    required int eventId,
    required int userId,
    required bool attendingWithSpouse,
  }) async {
    final Uri url = Uri.parse('$baseUrl/event/register-events'); // Adjust the API endpoint if different

    try {
      final Map<String, dynamic> requestBody = {
        "eventId": eventId,
        "userId": userId,
        "attendingWithSpouse": attendingWithSpouse,
      };

      final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Add other headers like authorization tokens if needed
          // 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
        },
        body: json.encode(requestBody), // Encode the body to JSON string
      );

      print(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Success: Parse the JSON response into your model
        final Map<String, dynamic> responseData = json.decode(response.body);
        return RegistrationResponse.fromJson(responseData);
      } else {
        // Handle non-200 status codes
        String errorMessage = "Failed to register for event. Status code: ${response.statusCode}";
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message']; // Use message from backend if available
          }
        } catch (e) {
          // If response body is not valid JSON, use generic message
          print("Error parsing error response: $e");
        }
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      // Handle network-related errors (e.g., no internet, host unreachable)
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      // Catch any other unexpected errors during the process
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
