import 'package:flutter/material.dart';
import '../../../models/player.dart';
import './choose_ability_screen.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import './login_screen.dart';

// MyHomePage class
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Example Player object, you can modify this as per your app's logic
  Player player = Player();

  // Sample ability choices; replace this with your actual ability choices
  // final List<String> abilities = ['Ability 1', 'Ability 2', 'Ability 3'];

  // Function to navigate to the ChooseAbilityScreen
  void _navigateToChooseAbilityScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseAbilityScreen(
          abilityChoices: abilities, // Pass your ability choices
          player: player, // Pass player object
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _navigateToChooseAbilityScreen,
              child: const Text('Go to Battle'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Amplify.Auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
