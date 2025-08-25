import 'dart:async';
import 'dart:convert';
import 'package:doubles/src/model/loginmodel.dart';
import 'package:doubles/src/service/auth/google_signin_api.dart';
import 'package:doubles/src/service/auth/signin_service.dart';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/button.dart';
import '../widgets/main_text.dart';
import '../widgets/text_field_input.dart';

const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/contacts.readonly',
];

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  SignInService _loginService = SignInService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // signInWithGoogle();
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

  // Future<void> _handleSignin() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() => _isLoading = true);
  //
  //     final loginResponse = await _loginService.signIn(
  //       _emailController.text,
  //       _passwordController.text,
  //     );
  //
  //     print(loginResponse.data);
  //
  //     if (loginResponse != null && loginResponse.data != null) {
  //       // ✅ Save token using SharedPreferences
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('authToken', loginResponse.token);
  //       await prefs.setInt('userId', loginResponse.data.id);
  //
  //
  //       // ✅ Navigate based on first time user
  //       if (loginResponse.data.firstTimeUser) {
  //         Navigator.pushNamed(context, "/profile", arguments: loginResponse.data);
  //       } else {
  //         Navigator.pushNamed(context, "/home", arguments: loginResponse.data);
  //       }
  //     }
  //
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _handleSignin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/signin'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 201) {
          final parsed = LoginResponse.fromJson(jsonDecode(response.body));

          if (parsed != null && parsed.data != null) {
            // ✅ Save token using SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('authToken', parsed.token);
            await prefs.setInt('userId', parsed.data.id);

            // ✅ Navigate based on first time user
            if (parsed.data.firstTimeUser) {
              Navigator.pushNamed(context, "/profile", arguments: parsed.data);
            } else {
              Navigator.pushNamed(context, "/home", arguments: parsed.data);
            }
          }
        } else {
          final errorBody = jsonDecode(response.body);
          _errorMessage = errorBody['message'] ?? 'Signup failed';
          _showSnackbar(_errorMessage!);
        }
      } catch (e) {
        print(e);
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

        final email = account.email;
        final firstName = account.displayName!.split(" ").first;
        final id = account.id.substring(account.id.length - 6);
        final password = "${firstName}@${id}";

        try {
          final response = await http.post(
            Uri.parse('$baseUrl/auth/signin'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          );

          setState(() => _isLoading = false);

          if (response.statusCode == 201) {
            final parsed = LoginResponse.fromJson(jsonDecode(response.body));

            if (parsed != null && parsed.data != null) {
              // ✅ Save token using SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('authToken', parsed.token);
              await prefs.setInt('userId', parsed.data.id);

              // ✅ Navigate based on first time user
              if (parsed.data.firstTimeUser) {
                Navigator.pushNamed(context, "/profile",
                    arguments: parsed.data);
              } else {
                Navigator.pushNamed(context, "/home", arguments: parsed.data);
              }
            }
          } else {
            final errorBody = jsonDecode(response.body);
            _errorMessage = errorBody['message'] ?? 'Signup failed';
            _showSnackbar(_errorMessage!);
          }
        } catch (e) {
          print(e);
          setState(() {
            _errorMessage = 'Something went wrong. Please try again.';
          });
          _showSnackbar(_errorMessage!);
        }
      } else {
        print("User cancelled the sign-in");
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
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 10),
          child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/login");
              },
              child: MainText(
                text: "Cancel",
                color: Colors.black,
              )),
        ),
        title: MainText(text: "Sign in", color: Colors.black),
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
                text: "ENTER YOUR EMAIL ADDRESS",
                color: Colors.black,
              ),
              Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
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
                        SizedBox(
                          height: 20,
                        ),
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
                        SizedBox(
                          height: 20,
                        ),
                        Button(
                          text: "Sign in",
                          onTap: _handleSignin,
                          width: MediaQuery.of(context).size.width,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: MainText(
                              text: "Forgot password?",
                              color: Colors.blue,
                              textAlign: TextAlign.start,
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        MainText(
                          text: "OTHER SIGN IN METHODS",
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                        SizedBox(
                          height: 10,
                        ),
                        Button(
                          text: "Continue with Facebook",
                          withIcon: true,
                          color: Colors.white,
                          iconImage: "assets/images/facebook.png",
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Button(
                          text: "Continue with X",
                          withIcon: true,
                          color: Colors.white,
                          iconImage: "assets/images/twitter.png",
                          width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
