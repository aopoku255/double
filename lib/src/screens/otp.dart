import 'dart:async';
import 'dart:convert';
import 'package:doubles/src/model/signup.dart';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:doubles/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String otpCode = "";
  late Timer _timer;
  int _remainingSeconds = 600; // 10 minutes = 600 seconds
  late int userId;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void handleSubmitOtp(String code) {
    setState(() {
      otpCode = code;
    });
    debugPrint("Entered OTP: $code");
  }

  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final args = ModalRoute.of(context)!.settings.arguments;
  //   if (args is SignupResponseModel) {
  //     userId = args.data.userId;
  //     print("User ID from OTP Screen: $userId");
  //   }
  // }

  Future<void> _verifyOtp() async {
    final url = Uri.parse('${baseUrl}/auth/verify-otp'); // Replace with your real endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'code': otpCode}),
      );



      if (response.statusCode == 200) {
        debugPrint("OTP verified successfully");
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/signin'); // Change route as needed
      } else {
        final body = jsonDecode(response.body);
        _showSnackbar(body['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      print(e);
      _showSnackbar('Something went wrong. Please try again.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final signupResponse = ModalRoute.of(context)?.settings.arguments as SignupResponseModel;
    userId = signupResponse.data.userId;
    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "We have sent an OTP to your email and phone number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            OtpTextField(
              numberOfFields: 6,
              onSubmit: handleSubmitOtp,
            ),
            const SizedBox(height: 16),
            Text(
              "OTP expires in ${_formatTime(_remainingSeconds)}",
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: otpCode.length == 6 && _remainingSeconds > 0 ? _verifyOtp : null,
              child: Button(text: "Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
