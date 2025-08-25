
import 'package:flutter/material.dart';

import '../themes/colors.dart';

class BoldText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final double fontSize;
  const BoldText(
      {super.key,
      required this.text,
      this.color = AppColors.primaryLigtBlue,
      this.textAlign,
      this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      maxLines: 5,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}
