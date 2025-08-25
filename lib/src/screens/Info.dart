import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MainText(text: "About The App", color: Colors.black,),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/kobina.jpg"))),
                ),
              ),
        
              SizedBox(height: 20,),
              MainText(text: "ABOUT DOUBLES", fontWeight: FontWeight.bold, color: Colors.black,),
              MainText(text: "Doubles is a quarterly workshop designed to engage couples in meaningful conversations that aim to nurture, support, and strengthen the bonds of marriage following God's divine institution of marriage. The workshop has been a game-changer for marriages since its launch in 2022, offering couples the necessary tools and unwavering support to enhance their relationships.", color: Colors.black, maxLines: 10,),
              SizedBox(height: 20,),
              MainText(text: "Our workshops are interactive and utilize practical tools and insights to empower couples to delve into pertinent discussions, enabling them to address issues proactively rather than allowing them to simmer unresolved", color: Colors.black, maxLines: 10,),
              SizedBox(height: 20,),
              MainText(text: "VISION", fontWeight: FontWeight.bold, color: Colors.black,),
              MainText(text: "A world where marriages thrive in love, unity, and God’s divine purpose.", color: Colors.black, maxLines: 5,),
              SizedBox(height: 20,),
              MainText(text: "MISSION", fontWeight: FontWeight.bold, color: Colors.black,),
              MainText(text: "A world where marriages thrive in love, unity, and God’s divine purpose.", color: Colors.black, maxLines: 5,),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),

    );
  }
}
