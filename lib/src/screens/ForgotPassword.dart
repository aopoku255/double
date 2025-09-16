import 'dart:convert';

import 'package:doubles/src/widgets/button.dart';
import 'package:doubles/src/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../model/signup.dart';
import '../service/baseUrl.dart';
import '../themes/colors.dart';
import '../widgets/main_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try{
        final response = await http.post(
          Uri.parse('$baseUrl/auth/forgot-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text.trim(),
          }),
        );
        setState(() => _isLoading = false);
        final parsed =
        SignupResponseModel.fromJson(jsonDecode(response.body));
        setState(() => _isLoading = false);
        if(response.statusCode == 200 || response.statusCode == 201){
          Navigator.pushNamed(context, '/otp', arguments: parsed);
        }
      }catch(err){
        setState(() {
          _errorMessage = 'Something went wrong. Please try again.';
        });
        setState(() => _isLoading = false);

      }
      debugPrint("Email: ${_emailController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: MainText(text: "Forgot password"),
        centerTitle: true,
      ),
      bottomSheet: const SizedBox(
        height: 30,
        child: MainText(
          text: "Doubles © 2025",
          color: Colors.black54,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enter email to used in registration",
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  label: "Email",
                  hintText: "example@email.com",
                  controller: _emailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!_isValidEmail(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Button(
                    text: "Submit",
                    isLoading: _isLoading,
                    width: MediaQuery.of(context).size.width,
                    onTap: _handleForgotPassword,
                    color: AppColors.primaryBtn)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
