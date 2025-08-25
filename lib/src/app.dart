import 'package:doubles/src/routes/routes.dart';
import 'package:doubles/src/screens/home.dart';
import 'package:doubles/src/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
          fontFamily: "Sora"
    ),
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
