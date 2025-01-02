import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_flutter/amplify_flutter.dart'; // Add Amplify for authentication

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Load user profile info from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        username = prefs.getString('username') ?? 'Guest';
        email = prefs.getString('email') ??
            'Not provided'; // Replace with actual logic if needed
      });
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> _logout() async {
    try {
      await Amplify.Auth.signOut();
      // Clear local preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to login screen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: username == null || email == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Profile Information",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text("Username: $username"),
                  Text("Email: $email"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
      ),
    );
  }
}
