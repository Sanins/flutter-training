import 'package:flutter/material.dart';
import 'battle_screen.dart';
import '../../../models/player.dart';

class CelebrationScreen extends StatelessWidget {
  final Player player;

  const CelebrationScreen({super.key, required this.player});

  void _goToNextBattle(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BattlePage(player: player)),
    );
  }

  void _returnHome(BuildContext context) {
    Navigator.popUntil(
        context, (route) => route.isFirst); // Return to the first screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Reward")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1, // Important to prevent infinite list
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: const Text('Go to next battle'),
                    onTap: () => _goToNextBattle(context), // Pass context here
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _returnHome(context),
              child: const Text('Return Home'),
            ),
          ),
        ],
      ),
    );
  }
}
