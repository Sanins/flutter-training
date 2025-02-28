import 'dart:math';
import 'package:flutter/material.dart';
import 'battle_screen.dart';
import '../../../models/player.dart';

class CelebrationScreen extends StatelessWidget {
  final Player player;
  final int battleNumber;

  const CelebrationScreen({
    super.key,
    required this.player,
    required this.battleNumber,
  });

  void _goToNextBattle(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BattlePage(
          player: player,
          battleNumber: battleNumber,
        ),
      ),
    );
  }

  void _returnHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  String _getRandomPotion() {
    List<String> potions = [
      'Small Health Potion',
      'Small Mana Potion',
      'Small Action Potion',
    ];
    final random = Random();
    return potions[random.nextInt(potions.length)];
  }

  void _showRandomPotion(BuildContext context) {
    String randomPotion = _getRandomPotion();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You received a potion!'),
          content: Text(randomPotion),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      _showRandomPotion(context);
    });

    return Scaffold(
      appBar: AppBar(
          title: const Text("Choose Your Reward"),
          automaticallyImplyLeading: false),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: const Text('Go to next battle'),
                    onTap: () => _goToNextBattle(context),
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
