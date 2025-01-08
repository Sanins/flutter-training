class EnemyEntity {
  final String name;
  final String description;
  final double bst;
  final double rarity;
  final double timesSeen;
  final bool isBoss;
  final List<Drop> drops;
  final String type;

  EnemyEntity({
    required this.name,
    required this.description,
    required this.bst,
    required this.rarity,
    required this.timesSeen,
    required this.isBoss,
    required this.type,
    required this.drops,
  });
}

enum Drop {
  healthPotion,
  manaPotion,
}

extension DropExtension on Drop {
  int get value {
    switch (this) {
      case Drop.healthPotion:
        return 1;
      case Drop.manaPotion:
        return 2;
    }
  }
}
