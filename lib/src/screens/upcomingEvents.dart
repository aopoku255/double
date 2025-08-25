import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/model/events.dart';
import 'package:doubles/src/service/events.dart';
import 'package:doubles/src/widgets/SessionCards.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({super.key});

  @override
  State<UpcomingEvents> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {

  final EventService _eventService = EventService();
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = _eventService.getAllEvents();
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
                return const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          BootstrapIcons.calendar2,
                          color: Colors.white,
                          size: 80,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MainText(
                          text: 'Opps! No upcoming events found',
                          color: Colors.white,
                        ),
                      ],
                    ));
              } else {
                final events = snapshot.data!;
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: events.map((event) {
                    // Calculate days remaining
                    String dayRemainingText = "";
                    bool isLiveEvent = false; // Initialize isLive to false

                    try {
                      DateTime eventStartDate = DateTime.parse(event.eventStartDate.toString());
                      DateTime now = DateTime.now();

                      // Only consider the date part for comparison for dayRemainingText
                      DateTime today = DateTime(now.year, now.month, now.day);
                      DateTime eventDateOnly = DateTime(eventStartDate.year, eventStartDate.month, eventStartDate.day);

                      final difference = eventDateOnly.difference(today);
                      if (difference.inDays > 1) {
                        dayRemainingText = "${difference.inDays} days remaining";
                      } else if (difference.inDays == 1) {
                        dayRemainingText = "1 day remaining";
                      } else if (difference.inDays == 0) {
                        dayRemainingText = "Today";

                        // --- Check if event is live ONLY IF it's today ---
                        try {
                          // Parse start and end times
                          // Assuming startTime and endTime are in "HH:mm:ss" format
                          final DateFormat timeFormat = DateFormat("HH:mm:ss");
                          DateTime parsedStartTime = timeFormat.parse(event.eventStartTime);
                          DateTime parsedEndTime = timeFormat.parse(event.eventEndTime); // Use event.eventEndTime

                          // Combine event date with parsed start and end times
                          DateTime eventStartDateTime = DateTime(
                            eventStartDate.year,
                            eventStartDate.month,
                            eventStartDate.day,
                            parsedStartTime.hour,
                            parsedStartTime.minute,
                            parsedStartTime.second,
                          );

                          DateTime eventEndDateTime = DateTime(
                            eventStartDate.year,
                            eventStartDate.month,
                            eventStartDate.day,
                            parsedEndTime.hour,
                            parsedEndTime.minute,
                            parsedEndTime.second,
                          );

                          // Get current time with only hour, minute, second
                          DateTime currentDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            now.hour,
                            now.minute,
                            now.second,
                          );

                          // Check if current time is between start and end times
                          if (currentDateTime.isAfter(eventStartDateTime) &&
                              currentDateTime.isBefore(eventEndDateTime)) {
                            isLiveEvent = true;
                          }
                        } catch (timeParseError) {
                          print("Error parsing time for live check: ${event.eventTitle} - $timeParseError");
                        }
                        // --- End of live check ---

                      } else {
                        dayRemainingText = "Event has passed";
                      }
                    } catch (e) {
                      print("Error parsing date for event: ${event.eventTitle} - $e");
                      dayRemainingText = "Date error";
                    }


                    return SessionCard(
                      image: "https://doubles-462709.el.r.appspot.com${event.eventImages}",
                      sessionTitle: event.eventTitle,
                      startTime: event.eventStartTime,
                      location: event.eventLocation,
                      eventDate: DateTime.parse(event.eventStartDate.toString()), // Pass DateTime object
                      dayRemaining: dayRemainingText, // Use the calculated value
                      isLive: isLiveEvent, // Pass the calculated isLive status
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