import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MainText(text: "Settings", color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/profile");
                    },
                    child: const ListTile(
                      leading: Icon(BootstrapIcons.person_circle),
                      title: MainText(text: "User Profile", color: Colors.black),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/info");
                    },
                    child: const ListTile(
                      leading: Icon(BootstrapIcons.info_circle),
                      title: MainText(text: "About The App", color: Colors.black),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear(); // remove the saved token

                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                    child: const ListTile(
                      leading: Icon(BootstrapIcons.box_arrow_right,
                          color: Colors.red),
                      title: MainText(text: "Logout", color: Colors.red),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
          // 🔹 Social media icons row
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
          MainText(text: "Follow us on:", color: Colors.black54,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(BootstrapIcons.instagram, size: 28, color: Colors.purple),
                      onPressed: () => _launchURL(
                          "https://www.instagram.com/doublestmc?igsh=MWgyYncwdWtwamN0OQ=="),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(BootstrapIcons.facebook, size: 28, color: Colors.blue),
                      onPressed: () => _launchURL(
                          "https://www.facebook.com/share/17bFnsq8QE/?mibextid=wwXIfr"),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(BootstrapIcons.tiktok, size: 28, color: Colors.black),
                      onPressed: () => _launchURL(
                          "https://www.tiktok.com/@doublestmc?_t=ZM-8zWz3dGBBeY&_r=1"),
                    ),IconButton(
                      icon: const Icon(BootstrapIcons.youtube, size: 28, color: Colors.red),
                      onPressed: () => _launchURL(
                          "https://www.youtube.com/@Doubles_tmc"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
