import 'package:flutter/material.dart';
import 'battle_screen.dart';
import '../../../models/player.dart';
import '../data/magic_abilities.dart';

class ChooseAbilityScreen extends StatelessWidget {
  final Player player;
  final int battleNumber;

  const ChooseAbilityScreen({
    super.key,
    required this.player,
    required this.battleNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Choose your starting abilities"),
          automaticallyImplyLeading: false),
      body: ListView.builder(
        itemCount: abilitiesWithStats.length,
        itemBuilder: (context, index) {
          final ability = abilitiesWithStats[index];
          return Card(
            child: ListTile(
              title: Text(ability.name),
              subtitle: Text(ability.description),
              trailing: Text(ability.type),
              onTap: () {
                player.applyAbility(ability);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BattlePage(player: player, battleNumber: 1),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
