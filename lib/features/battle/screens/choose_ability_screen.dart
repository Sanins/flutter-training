import 'package:flutter/material.dart';
import 'battle_screen.dart';
import '../../../models/ability.dart';
import '../../../models/player.dart';

// Example abilities
final abilities = [
  Ability(
    name: "Flaming Sword",
    description: "Your attacks deal +25% fire damage.",
    type: "Offensive",
    rarity: 2,
    applyEffect: (player) => player.attackPower *= 1.25,
  ),
  Ability(
    name: "Shield of Aegis",
    description: "Reduce damage taken by 15%.",
    type: "Defensive",
    rarity: 1,
    applyEffect: (player) => player.damageReduction += 0.15,
  ),
  Ability(
    name: "Lucky Charm",
    description: "Increase critical hit chance by 10%.",
    type: "Utility",
    rarity: 2,
    applyEffect: (player) => player.critChance += 0.1,
  ),
];

class ChooseAbilityScreen extends StatelessWidget {
  final List<Ability> abilityChoices;
  final Player player;
  final int battleNumber;

  const ChooseAbilityScreen({
    super.key,
    required this.abilityChoices,
    required this.player,
    required this.battleNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Reward")),
      body: ListView.builder(
        itemCount: abilityChoices.length,
        itemBuilder: (context, index) {
          final ability = abilityChoices[index];
          return Card(
            child: ListTile(
              title: Text(ability.name),
              subtitle: Text(ability.description),
              trailing: Text(ability.type),
              onTap: () {
                ability.applyEffect(player);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BattlePage(player: player, battleNumber: 1),
                  ),
                ); // Navigate to BattleScreen
              },
            ),
          );
        },
      ),
    );
  }
}
