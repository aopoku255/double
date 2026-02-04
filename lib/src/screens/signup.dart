import 'package:doubles/src/model/signup.dart';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:doubles/src/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
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

  // Controllers
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String? _fullPhoneNumber; // holds complete phone with country code
  String? _errorMessage;
  bool _isLoading = false;
  bool _isGoogleSignInLoading = false;

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
            'email': _emailController.text.trim(),
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'password': _passwordController.text,
            'phone': _fullPhoneNumber ?? _phoneNumberController.text,
          }),
        );

        setState(() => _isLoading = false);

        print(jsonDecode(response.body));

        if (response.statusCode == 201) {
          final parsed =
          SignupResponseModel.fromJson(jsonDecode(response.body));

          Navigator.pushNamed(
            context,
            '/otp',
            arguments: parsed,
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
        setState(() => _isLoading = false);
        _showSnackbar(_errorMessage!);
      }
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
    "768884005658-q8sdf1cftb83vkgmd2cht45q1ohsct0h.apps.googleusercontent.com",
    serverClientId:
    "768884005658-q8sdf1cftb83vkgmd2cht45q1ohsct0h.apps.googleusercontent.com",
  );

  Future<void> signInWithGoogle() async {
    try {
      setState(() => _isGoogleSignInLoading = true);

      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        // User canceled
        setState(() => _isGoogleSignInLoading = false);
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;

      // Safely extract names
      final fullName = account.displayName ?? "";
      final parts = fullName.split(" ");
      final firstName = parts.isNotEmpty ? parts.first : "";
      final lastName = parts.length > 1 ? parts.last : "";

      final email = account.email;
      final id = account.id;

      // Temporary password (only if backend requires it)
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

        if (response.statusCode == 201 || response.statusCode == 200) {
          final parsed = SignupResponseModel.fromJson(jsonDecode(response.body));
          Navigator.pushNamed(context, '/otp', arguments: parsed);
        } else if (response.statusCode == 409) {
          // User already exists → maybe login flow instead?
          _showSnackbar("Account already exists. Please log in.");
        } else {
          final errorBody = jsonDecode(response.body);
          _showSnackbar(errorBody['message'] ?? 'Signup failed');
        }
      } catch (e) {
        debugPrint(e.toString());
        _showSnackbar('Something went wrong. Please try again.');
      } finally {
        setState(() => _isGoogleSignInLoading = false);
      }
    } catch (e) {
      setState(() => _isGoogleSignInLoading = false);
      print("Error during Google sign-in: $e");
      _showSnackbar("Google sign-in failed. Please try again.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/homebanner.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    TextFieldInput(
                      label: "First Name",
                      controller: _firstNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First Name is required';
                        }
                        if (value.trim().length < 3) {
                          return 'First Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFieldInput(
                      label: "Last Name",
                      controller: _lastNameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last Name is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Last Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ✅ IntlPhoneField for phone number with country code
                    TextFieldInput(
                      label: "Phone Number",
                      isPhoneField: true,
                      hintText: "e.g. 54 509 8438",
                      controller: _phoneNumberController,
                      onPhoneChanged: (fullNumber) {
                        _fullPhoneNumber = fullNumber.replaceAll("+", "");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone Number is required';
                        }
                        if (value.length < 9) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),


                    const SizedBox(height: 20),
                    TextFieldInput(
                      isPasswordField: true,
                      label: "Password",
                      controller: _passwordController,
                      passwordGenerator: true,
                      validator: (value) {
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
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Button(
                      text: "Sign up",
                      onTap: _handleSignup,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.primaryBtn,
                      isLoading: _isLoading,

                    ),
                    // const SizedBox(height: 40),
                    // MainText(
                    //     text: "OTHER SIGN UP METHODS", color: Colors.black),
                    // const SizedBox(height: 10),
                    // Button(
                    //   text: "Continue with Google",
                    //   withIcon: true,
                    //   color: Colors.white,
                    //   iconImage: "assets/images/google.png",
                    //   width: MediaQuery.of(context).size.width,
                    //   isLoading: _isGoogleSignInLoading,
                    //   onTap: () {
                    //     signInWithGoogle();
                    //   },
                    // ),
                    const SizedBox(height: 50),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
