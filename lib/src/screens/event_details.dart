import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/model/event_registration_model.dart';
import 'package:doubles/src/model/registrants_model.dart';
import 'package:doubles/src/service/events.dart';
import 'package:doubles/src/themes/colors.dart';
import 'package:doubles/src/widgets/RegistrationDialog.dart';
import 'package:doubles/src/widgets/bold_text.dart';
import 'package:doubles/src/widgets/button.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/material.dart';
import 'package:doubles/src/model/events.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/OvalIcon.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final EventService registerEvent = EventService();
  late Future<List<Registrant>> _futureRegistrants;
  late int eventId;
  bool isRegisterLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRegisteredUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchRegisteredUser();
  }

  void fetchRegisteredUser() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("userId");
    if (userId != null && mounted) {
      setState(() {
        _futureRegistrants = registerEvent.getRegistrants(userId, eventId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Event event = ModalRoute.of(context)!.settings.arguments as Event;
    eventId = event.id;

    final now = DateTime.now();
    final isPastEvent = now.isAfter(event.eventEndDate);

    final startTime = DateFormat("HH:mm:ss").parse(event.eventStartTime);
    final endTime = DateFormat("HH:mm:ss").parse(event.eventEndTime);

    final formattedStartTime = DateFormat("hh:mm a").format(startTime);
    final formattedEndTime = DateFormat("hh:mm a").format(endTime);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:  Padding(
          padding: EdgeInsets.all(8.0),
          child: OvalIcon(icon: Icons.notifications_outlined, onPressed: (){
            Navigator.pushNamed(context, '/notifications');
          }),
        ),

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC052DF), Color(0xFF23236C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event banner
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      event.eventImages,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 50),
                    ),
                  )
                  ,
                  const SizedBox(height: 20),

                  BoldText(
                    text: event.eventTitle,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  // MainText(text: "Hosted by ${event.eventHost}"),
                  const SizedBox(height: 20),

                  // Date section
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 35,
                        color: Colors.white.withOpacity(0.40),
                        child: Center(
                          child: MainText(
                            text: DateFormat('MMM').format(event.eventStartDate), // e.g. Mar
                            fontSize: 10,
                          ),
                        ),
                      ),
                      MainText(
                        fontSize: 12,
                        text: DateFormat('d').format(event.eventStartDate), // e.g. 27
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      text: DateFormat('EEEE d MMMM').format(event.eventStartDate),
                      fontWeight: FontWeight.bold,
                    ),
                    MainText(
                      text: "$formattedStartTime - $formattedEndTime GMT",
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
                  const SizedBox(height: 10),

                  // Location section
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 35,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          BootstrapIcons.geo_alt,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: MainText(
                          text: event.eventLocation,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Registration / Ticket section
                  FutureBuilder<List<Registrant>>(
                    future: _futureRegistrants,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return _buildRegistrationBox(isPastEvent, event);
                      } else if (snapshot.hasData) {
                        return isPastEvent
                            ? _buildAskQuestionButton()
                            : _buildTicketBox(snapshot.data![0].qrcode);
                      }
                      return _buildRegistrationBox(isPastEvent, event);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Speakers
                  BoldText(
                    text: "Speakers",
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: event.eventHost.split(",").map((e) {
                      final parts = e.trim().split(" - ");
                      final name = parts[0];
                      final role = parts.length > 1 ? parts[1] : "";
                      return Row(
                        children: [
                          MainText(text: name),
                          const SizedBox(width: 8, height: 25),
                          MainText(text: "($role)"),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // About event
                  BoldText(
                    text: "About Event",
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  Html(
                    data: event.eventDescription,
                    style: {
                      "p": Style(color: Colors.white),
                      "li": Style(color: Colors.white),
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widgets extracted for clarity
  Widget _buildAskQuestionButton() {
    return Center(
      child: Button(
        text: "Ask a question",
        height: 40,
        width: MediaQuery.of(context).size.width - 100,
        color: Colors.green,
        // onTap: () {
        //   showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //       title: MainText(text: "Enter your question", color: Colors.black),
        //       content: Container(
        //         padding:
        //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //         decoration: BoxDecoration(
        //           border: Border.all(color: Colors.grey, width: 1.0),
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //         child: const TextField(
        //           maxLines: 5,
        //           decoration: InputDecoration(
        //             hintText: "Type your question here...",
        //             border: InputBorder.none,
        //           ),
        //         ),
        //       ),
        //       actions: [
        //         TextButton(
        //           onPressed: () => Navigator.of(context).pop(),
        //           child: const Text("Submit"),
        //         ),
        //         TextButton(
        //           onPressed: () => Navigator.of(context).pop(),
        //           child: const Text("Cancel"),
        //         ),
        //       ],
        //     ),
        //   );
        // },
        onTap: (){
          Navigator.pushNamed(context, "/questions");
        },
      ),
    );
  }

  Widget _buildTicketBox(String qrcodeUrl) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          MainText(text: "Below is your ticket to the event"),
          const SizedBox(height: 10),
          Image.network(qrcodeUrl),
        ],
      ),
    );
  }

  Widget _buildRegistrationBox(bool isPastEvent, Event event) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white.withOpacity(0.30),
            ),
            child: MainText(
              text: isPastEvent ? "Ask a question" : "Registration",
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            width: MediaQuery.of(context).size.width - 150,
            child: MainText(
              text: isPastEvent
                  ? "This event has ended"
                  : "Welcome! To join the event, please register below",
              maxLines: 2,
            ),
          ),
          isPastEvent ? _buildAskQuestionButton() :
          Center(
            child: Button(
              isLoading: isRegisterLoading,
              text: "Register",
              height: 40,
              width: MediaQuery.of(context).size.width - 100,
              color: Colors.purple,
              onTap: () => _showRegisterDialog(event),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog(Event event) {
    String? selectedOption = "0"; // default: Alone

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: MainText(
              text: "Who are you coming with?",
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text("Alone"),
                  value: "0",
                  groupValue: selectedOption,
                  onChanged: (value) =>
                      setStateDialog(() => selectedOption = value),
                ),
                RadioListTile<String>(
                  title: const Text("With my partner"),
                  value: "1",
                  groupValue: selectedOption,
                  onChanged: (value) =>
                      setStateDialog(() => selectedOption = value),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  setState(() => isRegisterLoading = true);
                  Navigator.of(context).pop();

                  final pref = await SharedPreferences.getInstance();
                  final userId = pref.getInt("userId") ?? 0;
                  final attendingWithSpouse = selectedOption == "1";

                  final response = await registerEvent.registerEvent(
                    eventId: event.id,
                    userId: userId,
                    attendingWithSpouse: attendingWithSpouse,
                  );

                  if (response.status == "Success" && mounted) {
                    setState(() => isRegisterLoading = false);
                    fetchRegisteredUser(); // 🔑 refresh the future to load QR code
                  }
                },
                child: const Text("Submit"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
            ],
          );
        });
      },
    );
  }

}
