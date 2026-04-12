import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool soundEffects = true;
  String selectedTheme = 'Dark Mode';

  String get _displayName {
    final user = AuthService.instance.currentUser;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    final email = _email;
    return email.isNotEmpty ? email.split('@').first : 'User';
  }

  String get _email => AuthService.instance.currentUser?.email ?? 'No email';

  String? get _photoUrl => AuthService.instance.currentUser?.photoURL;

  String get _initials {
    final name = _displayName;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Future<void> _logout() async {
    await AuthService.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Avatar & user info ─────────────────────────
          Center(
            child: Column(
              children: [
                _photoUrl != null && _photoUrl!.isNotEmpty
                    ? CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(_photoUrl!),
                      )
                    : Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF4A7BFF), Color(0xFF6C3FD0)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _initials,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                const SizedBox(height: 14),
                Text(
                  _displayName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 8),
                // Role badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A7BFF).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFF4A7BFF).withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    _email.toLowerCase().contains('lecturer')
                        ? 'Lecturer'
                        : 'Student',
                    style: const TextStyle(
                        color: Color(0xFF4A7BFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Theme ──────────────────────────────────────
          _sectionTitle('Appearance'),
          const SizedBox(height: 10),
          _card(
            child: Column(
              children: [
                _themeTile('Light Mode', Icons.light_mode),
                _divider(),
                _themeTile('Dark Mode', Icons.dark_mode),
                _divider(),
                _themeTile('System', Icons.settings_brightness),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Notifications ──────────────────────────────
          _sectionTitle('Notifications'),
          const SizedBox(height: 10),
          _card(
            child: Column(
              children: [
                _switchTile(
                  'Push Notifications',
                  'Reminders for deadlines and events',
                  Icons.notifications_outlined,
                  pushNotifications,
                  (v) => setState(() => pushNotifications = v),
                ),
                _divider(),
                _switchTile(
                  'Email Notifications',
                  'Weekly summaries and updates',
                  Icons.email_outlined,
                  emailNotifications,
                  (v) => setState(() => emailNotifications = v),
                ),
                _divider(),
                _switchTile(
                  'Sound Effects',
                  'Sounds for notifications and actions',
                  Icons.volume_up_outlined,
                  soundEffects,
                  (v) => setState(() => soundEffects = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Account ────────────────────────────────────
          _sectionTitle('Account'),
          const SizedBox(height: 10),
          _card(
            child: Column(
              children: [
                _infoTile(Icons.email_outlined, 'Email', _email),
                _divider(),
                _infoTile(
                    Icons.shield_outlined,
                    'Authentication',
                    AuthService.instance.currentUser?.providerData.isNotEmpty == true
                        ? AuthService.instance.currentUser!.providerData.first.providerId == 'google.com'
                            ? 'Google'
                            : 'Email & Password'
                        : 'Email & Password'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Logout ─────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Log Out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Builders ────────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8),
      );

  Widget _card({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );

  Widget _divider() =>
      const Divider(color: Colors.white12, height: 1, indent: 16, endIndent: 16);

  Widget _themeTile(String title, IconData icon) {
    final isSelected = selectedTheme == title;
    return ListTile(
      leading: Icon(icon,
          color: isSelected ? const Color(0xFF4A7BFF) : Colors.white54,
          size: 20),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF4A7BFF), size: 20)
          : null,
      onTap: () => setState(() {
        selectedTheme = title;
        themeNotifier.value = switch (title) {
          'Light Mode' => ThemeMode.light,
          'Dark Mode' => ThemeMode.dark,
          _ => ThemeMode.system,
        };
      }),
    );
  }

  Widget _switchTile(String title, String subtitle, IconData icon, bool value,
      ValueChanged<bool> onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.white54, size: 20),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFF4A7BFF),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.white54, size: 20),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: Text(value,
          style: const TextStyle(color: Colors.white54, fontSize: 13)),
    );
  }
}
