import 'package:doubles/src/screens/Appointment.dart';
import 'package:doubles/src/screens/Profile.dart';
import 'package:doubles/src/screens/Questions.dart';
import 'package:doubles/src/screens/Settings.dart';
import 'package:doubles/src/screens/events.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pages = [
    Events(),
    Appointment(),
    Settings(),
    Questions()
  ];

  final _bottomIcons = [
    BootstrapIcons.house,
    BootstrapIcons.calendar_event,
    BootstrapIcons.gear,
    BootstrapIcons.question_circle,
  ];
  final _bottomIconsFill = [
    BootstrapIcons.house_fill,
    BootstrapIcons.calendar_event_fill,
    BootstrapIcons.gear_fill,
    BootstrapIcons.question_circle_fill,
  ];
  final iconNames = [
    "Home",
    "Appointment",
    "Settings",
    "Questions"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,// or any highlight color
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // if you have more than 3 items
        items: List.generate(
          _bottomIcons.length,
              (index) => BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == index ? _bottomIconsFill[index] : _bottomIcons[index],
            ),
            label: iconNames[index],
          ),
        ),
      ),

      body: _pages[_selectedIndex],
    );
  }
}
