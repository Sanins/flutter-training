import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import '../../../models/User.dart';
import '../../../models/player.dart';
import './character_class_screen.dart';
import 'login_screen.dart'; // Import your Login Screen

class MyHomePage extends StatefulWidget {
  final String title;
  final String? initialUsername;
  final int? initialLevel;
  final int? initialCurrentExp;

  const MyHomePage({
    super.key,
    required this.title,
    this.initialUsername,
    this.initialLevel,
    this.initialCurrentExp,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? username; // Make username nullable
  int? level; // Make level nullable
  int? currentExp; // Make currentExp nullable
  Player player = Player();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    if (storedUsername != null) {
      // If username is in SharedPreferences, load it
      setState(() {
        username = storedUsername;
        level = prefs.getInt('level');
        currentExp = prefs.getInt('currentExp');
      });
    } else {
      // If no username is stored, fetch from DynamoDB
      await _syncUserDataFromBackend();
    }
  }

  Future<void> _syncUserDataFromBackend() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final result = await Amplify.API
          .query(
            request: ModelQueries.get(
              User.classType,
              UserModelIdentifier(id: user.userId),
            ),
          )
          .response;

      if (result.data != null) {
        final userData = result.data!;
        // Sync user data from backend (DynamoDB)
        setState(() {
          username = userData.username;
          level = userData.level ?? 1; // Default to 1 if null
          currentExp = userData.currentExp ?? 0; // Default to 0 if null
        });

        // Store it locally for future use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', userData.username ?? '');
        await prefs.setInt('level', userData.level ?? 1);
        await prefs.setInt('currentExp', userData.currentExp ?? 0);
      }
    } catch (e) {
      print('Error fetching user data from backend: $e');
    }
  }

  Future<void> _updateUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'username', username ?? 'Guest'); // Ensure a default
      await prefs.setInt('level', level ?? 1); // Ensure a default
      await prefs.setInt('currentExp', currentExp ?? 0); // Ensure a default

      // Sync to the backend (DynamoDB via Amplify API)
      final user = await Amplify.Auth.getCurrentUser();
      final updatedUser = User(
        id: user.userId,
        username: username ?? 'Guest', // Ensure a default value
        level: level ?? 1, // Ensure a default value
        currentExp: currentExp ?? 0, // Ensure a default value
        updatedAt: TemporalDateTime.now(),
        owner: user.userId,
      );

      final result =
          await Amplify.API.mutate(request: ModelMutations.update(updatedUser));
      print('User data updated: $result');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data updated successfully")),
      );
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update user data: $e")),
      );
    }
  }

  void _logout() async {
    await Amplify.Auth.signOut();
    // Clear local preferences, but don't reset stats if logged out
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('level');
    prefs.remove('currentExp');
    // Navigate to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _showUsernameModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? newUsername;
        return AlertDialog(
          title: const Text('Enter Your Username'),
          content: TextField(
            onChanged: (value) {
              newUsername = value;
            },
            decoration: const InputDecoration(hintText: "Username"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (newUsername != null && newUsername!.isNotEmpty) {
                  setState(() {
                    username = newUsername!;
                  });
                  await _updateUserData(); // Update local and remote data
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Username cannot be empty")),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToBattleScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChooseClassScreen(
              player: player) // Replace with your battle screen
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Username: $username'),
            Text('Level: $level'),
            Text('Current EXP: $currentExp'),
            ElevatedButton(
              onPressed: _navigateToBattleScreen,
              child: const Text('Go to Battle'),
            ),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
            ElevatedButton(
              onPressed: _showUsernameModal,
              child: const Text('Set Username'),
            ),
          ],
        ),
      ),
    );
  }
}
