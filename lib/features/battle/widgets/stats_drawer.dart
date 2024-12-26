import 'package:flutter/material.dart';
import '../../../models/player.dart';

class StatsDrawer extends StatelessWidget {
  final Player player; // Add player as a parameter
  final int health; // Add health as a parameter

  const StatsDrawer({Key? key, required this.player, required this.health})
      : super(key: key); // Update constructor to accept health

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stats',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Health: $health HP'), // Display health here
            const SizedBox(height: 20),
            Text('Attack Power: ${player.attackPower.toStringAsFixed(2)}'),
            Text('Crit Chance: ${player.critChance * 100}%'),
            const SizedBox(height: 20),
            // Add other stats as needed
          ],
        ),
      ),
    );
  }
}
