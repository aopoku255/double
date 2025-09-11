import 'dart:async';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (!kIsWeb) {
              setState(() => _isLoading = true);
            }
          },
          onPageFinished: (url) {
            if (!kIsWeb) {
              setState(() => _isLoading = false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse("https://doubles.zapier.app/"));

    if (kIsWeb) {
      // Fallback: remove loader after 3 seconds on web
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MainText(
          text: "Book Appointment",

          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          SizedBox(height: 120,),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],

      ),
    );
  }
}
