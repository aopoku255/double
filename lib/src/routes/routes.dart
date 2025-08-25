
import 'package:doubles/src/screens/Info.dart';
import 'package:doubles/src/screens/Profile.dart';
import 'package:doubles/src/screens/SplashScreen.dart';
import 'package:doubles/src/screens/event_details.dart';
import 'package:doubles/src/screens/events.dart';
import 'package:doubles/src/screens/login.dart';
import 'package:doubles/src/screens/onboarding_screen.dart';
import 'package:doubles/src/screens/otp.dart';
import 'package:doubles/src/screens/signup.dart';
import 'package:doubles/src/screens/singin.dart';
import 'package:flutter/cupertino.dart';

import '../screens/home.dart';

Map<String, WidgetBuilder> get appRoutes{
  return {
    '/': (context) => const SplashScreen(),
    '/onboarding': (context) => const OnboardingScreen(),
    '/login': (context) => const Login(),
    '/signin': (context) => const Signin(),
    '/otp': (context) => const Otp(),
    '/signup': (context) => const Signup(),
    '/events': (context) => const Events(),
    '/events-details': (context) => const EventDetails(),
    '/home': (context) => const Home(),
    '/profile': (context) => const Profile(),
    '/info': (context) => const Info(),

  };
  }