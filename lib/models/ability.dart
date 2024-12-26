import 'player.dart';

class Ability {
  final String name;
  final String description;
  final String type; // 'Offensive', 'Defensive', 'Utility', 'Passive'
  final int rarity; // 1 = Common, 2 = Rare, 3 = Epic
  final Function(Player)
      applyEffect; // A function to apply the effect in the game

  Ability({
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.applyEffect,
  });
}
