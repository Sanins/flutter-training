import 'package:flutter/material.dart';
import '../../../models/player.dart';
import './choose_ability_screen.dart';

class ChooseClassScreen extends StatelessWidget {
  const ChooseClassScreen({
    super.key,
    required this.player,
  });
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Class'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Your Class:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ClassButton(
              className: 'Mage',
              description:
                  'Masters of the arcane arts, Mages start with higher magic stats.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseAbilityScreen(
                      abilityChoices: abilities,
                      player: player,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ClassButton(
              className: 'Fighter',
              description:
                  'Fearless warriors, Fighters start with higher strength stats.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseAbilityScreen(
                      abilityChoices: abilities,
                      player: player,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ClassButton extends StatelessWidget {
  final String className;
  final String description;
  final VoidCallback onPressed;

  const ClassButton({
    super.key,
    required this.className,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            className,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
