import 'package:flutter/material.dart';
import '../../../models/player.dart';

class StatsDrawer extends StatelessWidget {
  final Player player; // Add player as a parameter
  final int health; // Add health as a parameter

  const StatsDrawer(
      {super.key,
      required this.player,
      required this.health}); // Update constructor to accept health

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('Attack Power', player.attackPower),
              _buildStatRow('Defense', player.defence),
              _buildStatRow('Magic Defense', player.magicDefence),
              _buildStatRow('Speed', player.speed),
              _buildStatRow('Health', player.health),
              _buildStatRow('Critical Chance', player.critChance * 100),
            ],
          )),
    );
  }
}

Widget _buildStatRow(String statName, double statValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Text(
      '$statName: ${statValue.toStringAsFixed(2)}',
      style: const TextStyle(fontSize: 16),
    ),
  );
}
