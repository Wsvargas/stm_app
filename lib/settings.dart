import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/login_page.dart';


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool soundEffects = true;

  String selectedTheme = "System";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF000000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            /// 🔹 THEME SECTION
            const Text(
              "Theme",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _themeTile("Light Mode"),
                  _themeTile("Dark Mode"),
                  _themeTile("System"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 NOTIFICATIONS
            const Text(
              "Notifications",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [

                  _switchTile(
                    "Push Notifications",
                    "Receive reminders for upcoming deadlines and events",
                    pushNotifications,
                    (val) => setState(() => pushNotifications = val),
                  ),

                  const Divider(color: Colors.white24),

                  _switchTile(
                    "Email Notifications",
                    "Receive weekly summaries and important updates",
                    emailNotifications,
                    (val) => setState(() => emailNotifications = val),
                  ),

                  const Divider(color: Colors.white24),

                  _switchTile(
                    "Sound Effects",
                    "Play sounds for notifications and actions",
                    soundEffects,
                    (val) => setState(() => soundEffects = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 LOGOUT BUTTON
            ElevatedButton(
              onPressed: () {
                // Navigate back to LoginPage
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false, 
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Theme Tile
  Widget _themeTile(String title) {
    final isSelected = selectedTheme == title;

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF4A7BFF))
          : null,
      onTap: () {
        setState(() {
          selectedTheme = title;

          // Update global theme
          switch (title) {
            case "Light Mode":
              themeNotifier.value = ThemeMode.light;
              break;
            case "Dark Mode":
              themeNotifier.value = ThemeMode.dark;
              break;
            case "System":
              themeNotifier.value = ThemeMode.system;
              break;
          }
        });
      },
    );
  }

  /// 🔹 Switch Tile
  Widget _switchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFF4A7BFF),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}