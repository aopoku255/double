import 'dart:convert';
import 'package:doubles/src/model/questions.dart';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PersonalQuestionService {
  /// Fetch all questions
  Future<List<PersonalQuestion>> fetchQuestions({required int userId}) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/questions/question/${userId}'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return PersonalQuestion.fromJsonList(jsonData);
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  /// Create a new question
  Future<PersonalQuestion> createQuestion({
    required int userId,
    required String question,
    required bool isPublic,
  }) async {
    try {
      final body = jsonEncode({
        "question": question.toString(),
        "isUser": true,
        "isPublic": isPublic
      });

      final response = await http.post(
        Uri.parse('$baseUrl/questions/question/$userId'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data.containsKey("data")) {
          return PersonalQuestion.fromJson(data["data"]);
        } else {
          // fallback if backend only returns { message: ... }
          return PersonalQuestion(
            id: 0,
            userId: userId,
            question: question,
            isUser: true,
            isPublic: isPublic,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating question: $e');
    }
  }
}
