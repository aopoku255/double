import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:doubles/src/service/baseUrl.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDeleting = false;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _deleteAccount() async {
    if (_isDeleting) return;

    setState(() => _isDeleting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");

      if (userId == null) {
        throw Exception("User ID not found. Please login again.");
      }

      final url = Uri.parse('$baseUrl/auth/delete-account');

      // If your backend requires auth, uncomment these:
      // final token = prefs.getString("token");
      // final headers = {
      //   'Content-Type': 'application/json',
      //   if (token != null) 'Authorization': 'Bearer $token',
      // };

      final response = await http.delete(
        url,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.body);
      }

      // Clear local storage after successful deletion
      await prefs.clear();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: $e")),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  void _confirmDeleteAccount() {
    if (_isDeleting) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "This action is permanent and cannot be undone. "
              "All your data will be deleted.\n\n"
              "Are you sure you want to continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteAccount();
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
                    onTap: () => Navigator.pushNamed(context, "/profile"),
                    child: const ListTile(
                      leading: Icon(BootstrapIcons.person_circle),
                      title: MainText(text: "User Profile", color: Colors.black),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, "/info"),
                    child: const ListTile(
                      leading: Icon(BootstrapIcons.info_circle),
                      title: MainText(text: "About Doubles", color: Colors.black),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  const Divider(),

                  // ✅ Delete Account
                  InkWell(
                    onTap: _confirmDeleteAccount,
                    child: ListTile(
                      leading: const Icon(BootstrapIcons.trash,
                          color: Colors.red),
                      title: const MainText(
                          text: "Delete Account", color: Colors.red),
                      trailing: _isDeleting
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                        CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.chevron_right),
                    ),
                  ),
                  const Divider(),

                  // Logout
                  InkWell(
                    onTap: _logout,
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
                const MainText(
                  text: "Follow us on:",
                  color: Colors.black54,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(BootstrapIcons.instagram,
                          size: 28, color: Colors.purple),
                      onPressed: () => _launchURL(
                        "https://www.instagram.com/doublestmc?igsh=MWgyYncwdWtwamN0OQ==",
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(BootstrapIcons.facebook,
                          size: 28, color: Colors.blue),
                      onPressed: () => _launchURL(
                        "https://www.facebook.com/share/17bFnsq8QE/?mibextid=wwXIfr",
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(BootstrapIcons.tiktok,
                          size: 28, color: Colors.black),
                      onPressed: () => _launchURL(
                        "https://www.tiktok.com/@doublestmc?_t=ZM-8zWz3dGBBeY&_r=1",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(BootstrapIcons.youtube,
                          size: 28, color: Colors.red),
                      onPressed: () => _launchURL(
                        "https://www.youtube.com/@Doubles_tmc",
                      ),
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
