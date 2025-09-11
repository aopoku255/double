import 'package:doubles/src/screens/Appointment.dart';
import 'package:doubles/src/screens/Profile.dart';
import 'package:doubles/src/screens/Questions.dart';
import 'package:doubles/src/screens/Settings.dart';
import 'package:doubles/src/screens/ShortVideos.dart';
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
    Questions(),
    ShortVideos()
  ];

  final _bottomIcons = [
    BootstrapIcons.house,
    BootstrapIcons.calendar_event,
    BootstrapIcons.gear,
    BootstrapIcons.question_circle,
    BootstrapIcons.camera_video
  ];
  final _bottomIconsFill = [
    BootstrapIcons.house_fill,
    BootstrapIcons.calendar_event_fill,
    BootstrapIcons.gear_fill,
    BootstrapIcons.question_circle_fill,
    BootstrapIcons.camera_video_fill
  ];
  final iconNames = [
    "Home",
    "Appointment",
    "Settings",
    "Questions",
    "videos"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,


      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200),
        ),

        onPressed: (){
          Navigator.pushNamed(context, "/qrcode");
        },
        backgroundColor: Colors.white,
        child: Icon(
          BootstrapIcons.qr_code_scan,
          color: Colors.black,
        ),
      ),
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
