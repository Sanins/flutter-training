import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_api/amplify_api.dart';
import '../../../models/User.dart';
import '../../../models/player.dart';
import '../../../models/item.dart';
import 'generate_player_screen.dart';
import './username_setup_screen.dart';
import '../widgets/header.dart';

class MyHomePage extends StatefulWidget {
  final String? initialUsername;
  final int? initialLevel;
  final int? initialCurrentExp;

  const MyHomePage({
    super.key,
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
  final List<Item> items = [
    Item(
      title: 'Health Potion',
      description: 'Restores a small amount of health.',
      heal: 50, // This item heals 50 health points
    ),
  ];

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
        if (userData.username == null || userData.username!.isEmpty) {
          // Navigate to UsernameSetupScreen if username is missing
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UsernameSetupScreen(),
              ),
            );
          });
        } else {
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
      } else {
        // Navigate to UsernameSetupScreen if no data is found
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UsernameSetupScreen(),
            ),
          );
        });
      }
    } catch (e) {
      print('Error fetching user data from backend: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
  }

  void _navigateToBattleScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GeneratePlayerScreen(
                player: player,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: "Home"),
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
          ],
        ),
      ),
    );
  }
}
