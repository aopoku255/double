import 'package:doubles/src/screens/pastEvents.dart';
import 'package:doubles/src/screens/upcomingEvents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/events.dart';
import '../widgets/OvalIcon.dart';
import '../widgets/SessionCards.dart';
import '../widgets/main_text.dart';
import '../model/events.dart'; // Import the event model if you have one

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  int _selectedChipIndex = 0;
  final String name = "Andrews";
  final List<String> _chipLabels = ["Upcoming events", "Past events"];
  final EventService _eventService = EventService();
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = _eventService.getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    // final List<dynamic> jsonData = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    // print(jsonData);

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Color(0xFFC052DF),
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: OvalIcon(icon: Icons.notifications_outlined),
          ),
          actions: [
            const OvalIcon(icon: Icons.more_vert),
            const SizedBox(width: 10),
          ],
          bottom:  TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.8),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            tabs: [
              Tab(text: 'Upcoming',),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UpcomingEvents(), // Replace with your widget
            PastEvents()    // Replace with your widget
          ],
        ),

      ),
    );

  }
}
