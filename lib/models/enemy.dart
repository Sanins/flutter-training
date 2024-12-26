class Boss {
  final String name;
  final String description;
  final double hp; // Health points of the boss
  final double attackPower; // Offensive power of the boss
  final String type; // 'Offensive', 'Defensive', 'Utility', 'Passive'
  final List<String> weaknesses; // List of elements the boss is weak against
  final List<String> abilities; // List of special abilities the boss can use

  Boss({
    required this.name,
    required this.description,
    required this.hp,
    required this.attackPower,
    required this.type,
    required this.abilities,
    required this.weaknesses,
  });
}
