import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: MainText(text: "Settings", color: Colors.black,),
        centerTitle: true,
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/profile");
              },
              child: ListTile(
                leading: Icon(BootstrapIcons.person_circle),
                title: MainText(text: "User Profile", color: Colors.black,),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, "/info");
              },
              child: ListTile(
                leading: Icon(BootstrapIcons.info_circle),
                title: MainText(text: "About The App", color: Colors.black,),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){
                // Navigator.pushNamed(context, "");
              },
              child: ListTile(
                leading: Icon(BootstrapIcons.shield_fill_exclamation),
                title: MainText(text: "Privacy Policy", color: Colors.black,),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            Divider(),


    InkWell(
        onTap: () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // remove the saved token

      // Navigate to login screen and clear the stack
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    },
    child: ListTile(
    leading: const Icon(BootstrapIcons.box_arrow_right, color: Colors.red),
    title: const MainText(text: "Logout", color: Colors.red),
    trailing: const Icon(Icons.chevron_right),
    ),
    ),

    Divider(),
          ],
        ),
      )
    );
  }
}
