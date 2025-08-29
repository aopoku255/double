import 'package:doubles/src/model/signup.dart';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:doubles/src/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/button.dart';
import '../widgets/main_text.dart';
import '../widgets/text_field_input.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text,
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'password': _passwordController.text,
            'phone': _phoneNumberController.text,
          }),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 201) {
          final parsed =
              SignupResponseModel.fromJson(jsonDecode(response.body));

          Navigator.pushNamed(
            context,
            '/otp',
            arguments: parsed, // Passing just the OTP data
          );
        } else {
          final errorBody = jsonDecode(response.body);
          _errorMessage = errorBody['message'] ?? 'Signup failed';
          _showSnackbar(_errorMessage!);
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Something went wrong. Please try again.';
        });
        _showSnackbar(_errorMessage!);
      }
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "768884005658-q8sdf1cftb83vkgmd2cht45q1ohsct0h.apps.googleusercontent.com",
      serverClientId:
          "768884005658-q8sdf1cftb83vkgmd2cht45q1ohsct0h.apps.googleusercontent.com");

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        // Get authentication tokens
        final GoogleSignInAuthentication auth = await account.authentication;
        final name = account.displayName!.split(" ");
        final firstName = name.first;
        final lastName = name.last;
        final email = account.email;
        final id = account.id;
        final password = "${firstName}@${id.substring(id.length - 6)}";

        try {
          final response = await http.post(
            Uri.parse('$baseUrl/auth/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'firstName': firstName,
              'lastName': lastName,
              'password': password,
              'phone': "0000000000",
            }),
          );

          setState(() => _isLoading = false);

          if (response.statusCode == 201) {
            final parsed =
                SignupResponseModel.fromJson(jsonDecode(response.body));

            Navigator.pushNamed(
              context,
              '/otp',
              arguments: parsed, // Passing just the OTP data
            );
          } else {
            final errorBody = jsonDecode(response.body);
            _errorMessage = errorBody['message'] ?? 'Signup failed';
            _showSnackbar(_errorMessage!);
          }
        } catch (e) {
          setState(() {
            _errorMessage = 'Something went wrong. Please try again.';
          });
          _showSnackbar(_errorMessage!);
        }
      } else {
        // print("User cancelled the sign-in");
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: MainText(text: "Sign up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainText(
                text: "GET STARTED WITH DOUBLES",
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      TextFieldInput(
                        label: "Email",
                        hintText: "user@gmail.com",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!_isValidEmail(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFieldInput(
                        label: "First Name",
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFieldInput(
                        label: "Last Name",
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFieldInput(
                        label: "Phone Number",
                        controller: _phoneNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone Number is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFieldInput(
                        isPasswordField: true,
                        label: "Password",
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Button(
                        text: "Sign up",
                        onTap: _handleSignup,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.primaryBtn,
                      ),
                      SizedBox(height: 40),
                      MainText(
                          text: "OTHER SIGN IN METHODS", color: Colors.black),
                      SizedBox(height: 10),
                      Button(
                        text: "Continue with Google",
                        withIcon: true,
                        color: Colors.white,
                        iconImage: "assets/images/google.png",
                        width: MediaQuery.of(context).size.width,
                        onTap: () {
                          signInWithGoogle();
                        },
                      ),
                      SizedBox(height: 10),
                      Button(
                        text: "Continue with Facebook",
                        withIcon: true,
                        color: Colors.white,
                        iconImage: "assets/images/facebook.png",
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(height: 10),
                      Button(
                        text: "Continue with X",
                        withIcon: true,
                        color: Colors.white,
                        iconImage: "assets/images/twitter.png",
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
