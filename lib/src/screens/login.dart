// import 'package:dachurchman/src/layouts/layout.dart';
// import 'package:dachurchman/src/provider/verify_email_provider.dart';
// import 'package:dachurchman/src/themes/colors.dart';

import 'package:doubles/src/layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bold_text.dart';
import '../widgets/button.dart';
import '../widgets/main_text.dart';
import '../widgets/wave_clipper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

// ADD A CONSENT SCREEN BEFORE THE LOGIN

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _checkForToken();
  }

  Future<void> _checkForToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null && token.isNotEmpty) {
      // ✅ Token found – navigate to events screen
      Navigator.pushReplacementNamed(context, '/home'); // or use '/events' route
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      havePadding: false,
      title: "Doubles",
      centerTitle: true,
      bottomSheet: const SizedBox(
        height: 30,
        child: MainText(
          text: "Doubles © 2025",
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.42,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/redbull.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            margin: const EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // User account image

                // const SizedBox(height: 20),
                // Input fields wrapped in a container for spacing
                Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),

                ),
                const SizedBox(height: 20),
                BoldText(text: "Welcome", color: Colors.black, fontSize: 30,),
                SizedBox(height: 5,),
                MainText(text: "Get started with your account", color: Colors.black,),
                SizedBox(height: 20,),
                Button(text: "Sign in", onTap: (){
                  Navigator.pushNamed(context, "/signin");
                },),
                SizedBox(height: 20,),
                Button(text: "Sign up", onTap: (){
                  Navigator.pushNamed(context, "/signup");
                }, ),
                SizedBox(height: 20,),
                Button(text: "Sign in as a guest"),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
