

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
  EventService registerEvent = EventService();
  late Future<List<Registrant>> _futureRegistrants;
  late int eventId;

  @override
  void initState() {
    super.initState();
    fetchRegisteredUser();
  }

  void fetchRegisteredUser() async {
    final pref = await SharedPreferences.getInstance();
    final userId = await pref.getInt("userId");
    setState(() {
      _futureRegistrants = registerEvent.getRegistrants(userId!, eventId);
    });


  }


  @override
  Widget build(BuildContext context) {

    final Event event = ModalRoute.of(context)!.settings.arguments as Event;
    setState(() {
      eventId = event.id;
    });
    DateTime now = DateTime.now();
    bool isPastEvent = now.isAfter(event.eventEndDate);
    final DateTime startTime = DateFormat("HH:mm:ss").parse(event.eventStartTime);
    final DateTime endTime = DateFormat("HH:mm:ss").parse(event.eventEndTime);
    final String formattedStartTime = DateFormat("hh:mm a").format(startTime);
    final String formattedEndTime = DateFormat("hh:mm a").format(endTime);
    return  Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: OvalIcon(icon: Icons.notifications_outlined),
        ),
        actions: [
          const OvalIcon(icon: Icons.more_vert),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      // margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width - 20,
                      height: 500,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("http://10.0.2.2:8080${event.eventImages}"), fit: BoxFit.cover), borderRadius: const BorderRadius.all(Radius.circular(20))),
                        )
                        ),
                    SizedBox(height: 20,),
                    BoldText(text: event.eventTitle, color: Colors.white, fontSize: 20,),
                    MainText(text: "Hosted by ${event.eventHost}"),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Container(
                          width: 35,

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: Column(
                            children: [
                              Container(

                                child: Center(child: MainText(text: "Mar", fontSize: 10,)),
                                color: Colors.white.withOpacity(0.40),
                                width: 35,
                              ),
                              MainText(text: "27")
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText(text: DateFormat('EEEE d MMMM').format(event.eventStartDate), fontWeight: FontWeight.bold,),
                            MainText(text: "${formattedStartTime} - ${formattedEndTime} GMT", fontSize: 12,),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 35,
                          padding: EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,
                                  width: 1.0
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(4))
                          ),
                          child: Icon(BootstrapIcons.geo_alt, color: Colors.white, size: 15,)
                        ),
                        SizedBox(width: 10,),
                        Container(width: MediaQuery.of(context).size.width - 100, child: MainText(text: event.eventLocation, maxLines: 1,))
                      ],
                    ),
                    SizedBox(height: 20,),

                    FutureBuilder<List<Registrant>>(future: _futureRegistrants, builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return isPastEvent ? Center(
                          child: Button(
                            text: "Ask a question",
                            height: 40,
                            width: MediaQuery.of(context).size.width - 100,
                            color: Colors.green,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: MainText(text: "Enter your question", color: Colors.black,),
                                        content: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey, // Border color
                                              width: 1.0,         // Border thickness
                                            ),
                                            borderRadius: BorderRadius.circular(8), // Optional rounded corners
                                          ),
                                          child: TextField(
                                            maxLines: 5, // You can also use `null` for unlimited
                                            decoration: const InputDecoration(
                                              hintText: "Type your question here...",
                                              border: InputBorder.none, // Use container's border only
                                            ),
                                          ),
                                        )
                                        ,

                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Submit question logic goes here
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Submit"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: Text("Cancel"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ) : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(

                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), color: Colors.white.withOpacity(0.30)),
                                child: MainText(text: isPastEvent ? "Ask a question" : "Registration",),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  width: MediaQuery.of(context).size.width - 150,
                                  child: MainText(text: isPastEvent ? "This event has ended" : "Welcome! To join the event, please register below", maxLines: 2,)),
                              Center(
                                child: Button(
                                  text: "Register",
                                  height: 40,
                                  width: MediaQuery.of(context).size.width - 100,
                                  color: Colors.purple,
                                  onTap: () {
                                    String? selectedOption = "Alone"; // default value

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
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
                                                    title: Text("Alone"),
                                                    value: "0",
                                                    groupValue: selectedOption,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedOption = value;
                                                      });

                                                    },
                                                  ),
                                                  RadioListTile<String>(
                                                    title: Text("With my wife"),
                                                    value: "1",
                                                    groupValue: selectedOption,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedOption = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    // Do something with selectedOption

                                                    bool selected = selectedOption == "0" ? false : true;
                                                    final pref = await SharedPreferences.getInstance();
                                                    final userId = await pref.getInt("userId") ?? 0;
                                                    final eventId = event.id;

                                                    final response = await registerEvent.registerEvent(eventId: eventId, userId: userId, attendingWithSpouse: selected);
                                                    if(response.status == "Success"){

                                                    }

                                                  },
                                                  child: Text("Submit"),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: Text("Cancel"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),


                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return isPastEvent ? Center(
                          child: Button(
                            text: "Ask a question",
                            height: 40,
                            width: MediaQuery.of(context).size.width - 100,
                            color: Colors.green,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: MainText(text: "Enter your question", color: Colors.black,),
                                        content: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey, // Border color
                                              width: 1.0,         // Border thickness
                                            ),
                                            borderRadius: BorderRadius.circular(8), // Optional rounded corners
                                          ),
                                          child: TextField(
                                            maxLines: 5, // You can also use `null` for unlimited
                                            decoration: const InputDecoration(
                                              hintText: "Type your question here...",
                                              border: InputBorder.none, // Use container's border only
                                            ),
                                          ),
                                        )
                                        ,

                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Submit question logic goes here
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Submit"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: Text("Cancel"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ) : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              MainText(text: "Below is your ticket to the event"),
                              SizedBox(height: 10,),
                              Image.network("https://doubles-462709.el.r.appspot.com${snapshot.data?[0].qrcode}"),
                            ],
                          ),
                        );
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(

                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), color: Colors.white.withOpacity(0.30)),
                              child: MainText(text: isPastEvent ? "Ask a question" : "Registration",),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                width: MediaQuery.of(context).size.width - 150,
                                child: MainText(text: isPastEvent ? "This event has ended" : "Welcome! To join the event, please register below", maxLines: 2,)),
                          Center(
                              child: Button(
                                text: "Register",
                                height: 40,
                                width: MediaQuery.of(context).size.width - 100,
                                color: Colors.purple,
                                onTap: () {
                                  String? selectedOption = "Alone"; // default value

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
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
                                                  title: Text("Alone"),
                                                  value: "0",
                                                  groupValue: selectedOption,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedOption = value;
                                                    });

                                                  },
                                                ),
                                                RadioListTile<String>(
                                                  title: Text("With my wife"),
                                                  value: "1",
                                                  groupValue: selectedOption,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedOption = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  // Do something with selectedOption

                                                  bool selected = selectedOption == "0" ? false : true;
                                                  final pref = await SharedPreferences.getInstance();
                                                  final userId = await pref.getInt("userId") ?? 0;
                                                  final eventId = event.id;

                                                  final response = await registerEvent.registerEvent(eventId: eventId, userId: userId, attendingWithSpouse: selected);
                                                  if(response.status == "Success"){
                                                     fetchRegisteredUser();
                                                  }

                                                },
                                                child: Text("Submit"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: Text("Cancel"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),


                          ],
                        ),
                      );
                    }),


                    SizedBox(height: 20,),
                    BoldText(text: "About Event", fontSize: 14, color: Colors.white,),
                    Html(data: event.eventDescription, style: {
                      "p": Style(color: Colors.white),
                      "li": Style(color: Colors.white)
                    },),

                    Divider(

                    )
                  ],
                ),
              ),
            ),
          )
      )
    );
  }
}
