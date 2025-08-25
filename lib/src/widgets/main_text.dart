// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../themes/colors.dart';

class MainText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  const MainText({
    Key? key,
    required this.text,
    this.textAlign,
    this.color = AppColors.primaryWhite,
    this.fontSize = 14, this.fontWeight, this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
