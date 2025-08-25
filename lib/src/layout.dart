
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final bool? showLogin;
  final bool? secondAppBar;
  final double padding;
  final bool? centerTitle;
  final String title;
  final double fontSize;
  final bool? havePadding;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  const Layout({
    super.key,
    required this.body,
    this.showLogin = false,
    this.secondAppBar = false,
    this.padding = 20,
    this.centerTitle = false,
    this.title = "DACHURCHMAN",
    this.fontSize = 14,
    this.havePadding = true,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: havePadding!
            ? EdgeInsets.symmetric(horizontal: padding, vertical: 20)
            : const EdgeInsets.all(0),
        child: body,
      ),
      bottomSheet: bottomSheet,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
