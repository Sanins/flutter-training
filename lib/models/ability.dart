class Ability {
  final String name;
  final String description;
  final bool utility;
  final String type; // 'Offensive', 'Defensive', 'Utility', 'Magic', 'Passive'
  final int rarity; // 1 = Common, 2 = Rare, 3 = Epic
  final double? damage; // Optional for abilities with damage
  final double? accuracy; // Optional for abilities with accuracy

  Ability({
    required this.name,
    required this.description,
    required this.type,
    required this.utility,
    required this.rarity,
    this.damage,
    this.accuracy,
  });
}
