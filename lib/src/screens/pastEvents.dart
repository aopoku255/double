import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/model/events.dart';
import 'package:doubles/src/service/events.dart';
import 'package:doubles/src/widgets/SessionCards.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/material.dart';

class PastEvents extends StatefulWidget {
  const PastEvents({super.key});

  @override
  State<PastEvents> createState() => _PastEventsState();
}

class _PastEventsState extends State<PastEvents> {
  final EventService _eventService = EventService();
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = _eventService.getPastEvents();
  }

  Future<void> _refreshEvents() async {
    setState(() {
      _futureEvents = _eventService.getAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFC052DF),
            Color(0xFF23236C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshEvents,
          child: FutureBuilder<List<Event>>(
            future: _futureEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(BootstrapIcons.calendar2, color: Colors.white, size: 80,),
                    SizedBox(height: 20,),
                    MainText(text: 'Opps! No upcoming events found', color: Colors.white,),
                  ],
                ));
              } else {
                final events = snapshot.data!;
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: events.map((event) {
                    return SessionCard(
                      image: "https://doubles-462709.el.r.appspot.com${event.eventImages}",
                      sessionTitle: event.eventTitle,
                      startTime: event.eventStartTime,
                      location: event.eventLocation,
                      eventDate: event.eventStartDate,
                      dayRemaining: "",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/events-details",
                          arguments: event,
                        );
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
