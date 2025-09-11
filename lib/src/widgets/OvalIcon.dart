import 'dart:ui';
import 'package:flutter/material.dart';

class OvalIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed; // custom function

  const OvalIcon({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.white.withOpacity(0.3),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed, // use the passed function
          ),
        ),
      ),
    );
  }
}
