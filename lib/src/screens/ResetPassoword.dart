import 'dart:convert';

import 'package:doubles/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../service/baseUrl.dart';
import '../themes/colors.dart';
import '../widgets/main_text.dart';
import '../widgets/text_field_input.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  late int userId;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null; // only check equality here
  }
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'), // ✅ make sure endpoint matches backend
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId, // or 'userId': userId, depending on your backend
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ success
        Navigator.pushNamed(context, "/signin");
        _showSnackbar(data['message'] ?? "Password reset successful", color: Colors.green.shade700);
      } else {

        _showSnackbar(data['message'] ?? "Something went wrong");
      }
    } catch (error) {
      setState(() => _isLoading = false);
      _showSnackbar("An error occurred. Please try again.");
    }
  }


  void _showSnackbar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color ?? Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    userId = ModalRoute.of(context)?.settings.arguments as int;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: const MainText(text: "Reset password"),
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
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MainText(
                  text: "Continue to reset your password",
                  fontSize: 24,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  isPasswordField: true,
                  label: "Password",
                  controller: _passwordController,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  isPasswordField: true,
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 20),
                Button(
                  text: "Reset",
                  isLoading: _isLoading,
                  width: MediaQuery.of(context).size.width - 20,
                  color: AppColors.primaryBtn,
                  onTap: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
