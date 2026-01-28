import 'dart:convert';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:doubles/src/themes/colors.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Checkin extends StatefulWidget {
  const Checkin({super.key});

  @override
  State<Checkin> createState() => _CheckinState();
}

class _CheckinState extends State<Checkin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late MobileScannerController _scannerController; // <-- add controller
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scannerController.dispose(); // <-- dispose scanner controller
    super.dispose();
  }

  /// Send check-in request
  Future<void> _checkinUser(int eventId) async {
    setState(() {
      isProcessing = true;
    });
    _scannerController.stop(); // <-- disable scanner when loading

    try {
      // Get userId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found in Shared Preferences")),
        );
        return;
      }

      final url = Uri.parse("${baseUrl}/event/checkin");
      final body = jsonEncode({"userId": userId, "eventId": eventId});

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: MainText(text: "Check-in successful"), backgroundColor: Colors.green,),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: MainText(text: data["message"] ?? "An error occurred"), backgroundColor: Colors.red,),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: MainText(text: "Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
      _scannerController.start(); // <-- re-enable scanner when done
    }
  }


  Widget _buildScannerOverlay(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = constraints.maxWidth * 0.8;
        double left = (constraints.maxWidth - size) / 2;
        double top = (constraints.maxHeight - size) / 2;

        return Stack(
          children: [
            // Square border
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // Moving bar
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: left,
                  top: top + (size * _animation.value),
                  child: Container(
                    width: size,
                    height: 2,
                    color: AppColors.primaryBtn,
                  ),
                );
              },
            ),
            // Text
            Positioned(
              left: 0,
              right: 0,
              top: top + size + 20,
              child: const Center(
                child: Text(
                  "Scan QR Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MainText(
          text: "Scan QR Code",
          color: AppColors.primaryBtn,
        ),
        centerTitle: true,
        foregroundColor: AppColors.primaryBtn,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController, // <-- use controller here
            onDetect: (capture) async {
              if (isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  try {
                    final eventId = int.parse(barcode.rawValue!);
                    await _checkinUser(eventId);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid QR Code")),
                    );
                  }
                }
              }
            },
          ),
          _buildScannerOverlay(context),
          if (isProcessing)
            const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }
}
